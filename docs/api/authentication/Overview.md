---
tags:
  - Authentication-Endpoints
  - Overview
---

This section describes the authentication system for OpenChampPS holisticly. Reading the releated technical detailing is recomended. 

## Authentication Architecture

OpenChampPS's' authentication system uses **HTTP and WebSocket** endpoints:

### Transport Protocols

| Protocol      | Use Case                                        | Registration | Login | Token Auth | Logout |
| :---------    | :------------------------------------------     | :----------- | :---- | :--------- | :----- |
| **HTTP**      | Initial registration only                       | ✓            | ✗     | ✗          | ✗      |
| **WebSocket** | Authentication + session management             | ✓            | ✓     | ✓          | ✓      |

### Authentication Methods

OpenChampPS currently supports three authentication methods all using WebSocket:

| Method                        | Use Case                                   | 
| :---------                    | :------------------------------------------|
| **Username/Password Login**   | For accessing a token on a new session     |
| **Token-Based Authentication**| For maintaining or reviving a session      |
| **Registration login**        | One time for fluid access to auth          |

---

## Endpoint Quick Reference

#### **User Registration**

| Endpoint         | Auto-Login |
| :-------         | :--------- |
| `POST /register` | No         |
| `WS: register`   | Yes        |

#### **User Authentication**

| Endpoint         | Input                        | Recommended usage |
| :-------         | :----                        | :------- |
| `WS: login`      | username + password          | Initial authentication |
| `WS: token_auth` | token (UUID)                 | Session restoration|
| `WS: register`   | username + password + email* | Registration|

**Email is toggleable via env varible (see guide)* 

#### **User Logout**

| Endpoint | Effect |
| :------- | :----- |
| `WS: logout` | Clears client authentication state|

---

## Authentication Sequence

```mermaid
sequenceDiagram
    participant C as Client
    participant S as OpenChampPS
    participant D as Database

    Note over C,D: Registration (HTTP Example)
    C->>S: POST /register (username, password, email)
    activate S
    S->>S: Validate & hash password
    S->>D: Insert user record
    D-->>S: User created
    S-->>C: 201 Created
    deactivate S
    
    Note over C,D: Authentication
    C->>S: WS: login (username, password)
    activate S
    S->>D: Query user credentials
    D-->>S: Return password hash
    S->>S: Verify password
    S->>S: Generate auth token
    S->>D: Store token
    D-->>S: Token stored
    S-->>C: auth_success (username, token)
    deactivate S
    
    Note over C,S: Client stores token for future use
    
    Note over C,D: Active Session
    C->>S: Application requests...
    S-->>C: Application responses...
    
    Note over C,D: Logout
    C->>S: WS: logout
    activate S
    S->>S: Clear client auth state
    S-->>C: logged_out
    deactivate S
    
    Note over C,D: Reconnection (using saved token)
    C->>S: WS: token_auth (saved token)
    activate S
    S->>D: Query token validity
    D-->>S: Token data & username
    S->>S: Verify token expiration
    S->>D: Update token last_used_at
    D-->>S: Updated
    S-->>C: auth_success (username, token)
    deactivate S
```

