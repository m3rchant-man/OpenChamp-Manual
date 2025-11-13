---
tags:
  - Authentication-Endpoints
---

This endpoint authenticates a user with a token via WebSocket connection to an OpenChampPS instance.

### Request

`WebSocket Endpoint: /ws`

**Message Type:** `token_auth`

---

### Input Schema


#### Message Structure

| Field     | Type   | Description                              | Required |
| :-------- | :----- | :--------------------------------------- | :------- |
| `type`    | String | Must be `token_auth` for token requests. | Yes      |
| `payload` | Object | Contains the authentication token.       | Yes      |

#### Payload Fields

| Field   | Type   | Description                                | Required | Constraints                |
| :------ | :----- | :----------------------------------------- | :------- | :------------------------- |
| `token` | String | The user's authentication token (UUID).    | Yes      | Valid UUID format          |

---

### Output Schema

#### Response Message (`auth_success`)

| Field     | Type   | Description                                    |
| :-------- | :----- | :--------------------------------------------- |
| `type`    | String | Will be `auth_success` for successful login.   |
| `payload` | Object | Contains authentication details.               |

#### Payload Fields

| Field      | Type   | Description                                    |
| :--------- | :----- | :--------------------------------------------- |
| `username` | String | The authenticated user's username.             |
| `token`    | String | Authentication token for subsequent requests.  |

---

### Error Responses

#### Error Codes


| Message Type   | Error Code/Message              | Description                                     |
| :------------- | :------------------------------ | :---------------------------------------------- |
| `auth_error`   | `Invalid token format`          | The token message payload is malformed.         |
| `auth_error`   | `Invalid or expired token`      | The provided token is invalid or has expired.   |

---

### Sequence Diagram
```mermaid
sequenceDiagram
    participant C as Client
    participant S as OpenChampPS
    participant D as Database

    C->>S: 1. Authentication Request (Send Token)
    activate S
    
    S->>S: Verify format (Syntactic Check)
    
    alt Token Format Invalid
        S-->>C: 2. "auth_error" Invalid token format
        deactivate S 
    else Token Format Valid
        S->>D: 2. Query token validity & user info (Database Lookup)
        activate D
        D-->>S: 3. Return token data and username
        deactivate D
        
        S->>S: Verify token expiration and validity (Temporal Check)
        
        alt Token Invalid or Expired
            S-->>C: 4. "auth_error" Invalid or expired token
        else Token Valid
            S->>D: 4. Update token last_used_at timestamp
            activate D
            D-->>S: 5. Confirm update
            deactivate D
            S-->>C: 6. "auth_success" OK

        end
    end
```
### Example

This example demonstrates authenticating a user with an authentication token.

!!! example "User Login via Token"

    **WebSocket Connection**
    ```javascript
    const ws = new WebSocket('ws://<your-server-address>/ws');
    ```

    **Request Message**
    ```json
    {
      "type": "token_auth",
      "payload": {
        "token": "550e8400-e29b-41d4-a716-446655440000"
      }
    }
    ```

    **Response Message (auth_success)**
    ```json
    {
      "type": "auth_success",
      "payload": {
        "username": "jane.doe",
        "token": "550e8400-e29b-41d4-a716-446655440000"
      }
    }
    ```

    **Error Response (auth_error)**
    ```json
    {
      "type": "auth_error",
      "payload": {
        "message": "Invalid or expired token"
      }
    }
    ```




