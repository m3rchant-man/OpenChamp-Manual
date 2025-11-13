---
tags:
  - Authentication-Endpoints
---

This endpoint authenticates a user with username and password credentials via WebSocket connection to an OpenChampPS instance.

### Request

`WebSocket Endpoint: /ws`

**Message Type:** `login`

---

### Input Schema


#### Message Structure

| Field     | Type   | Description                              | Required |
| :-------- | :----- | :--------------------------------------- | :------- |
| `type`    | String | Must be `login` for login requests.      | Yes      |
| `payload` | Object | Contains the authentication credentials. | Yes      |

#### Payload Fields

| Field      | Type   | Description                                | Required | Constraints            |
| :--------- | :----- | :----------------------------------------- | :------- | :--------------------- |
| `username` | String | The user's unique username.                | Yes      | Minimum 3 characters   |
| `password` | String | The user's password.                       | Yes      | Minimum 6 characters   |

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
| `auth_error`   | `Invalid login format`          | The login message payload is malformed.         |
| `auth_error`   | `Invalid username or password`  | The provided credentials are incorrect.         |

---

### Sequence Diagram
```mermaid
sequenceDiagram
    participant C as Client
    participant S as OpenChampPS
    participant D as Database

    C->>S: 1. Authentication Request (Send Credentials)
    activate S
    
    S->>S: Verify format (Syntactic Check)
    
    alt Login Format Invalid
        S-->>C: 2. "auth_error" Invalid login format
        deactivate S 
    else Login Format Valid
        S->>D: 2. Query user credentials/hash (Database Lookup)
        activate D
        D-->>S: 3. Return stored hash
        deactivate D
        
        S->>S: Verify provided password against stored hash (Cryptographic Check)
        
        alt Credentials Invalid
            S-->>C: 4. "auth_error" Invalid username or password
        else Credentials Valid
            S-->>C: 4. "auth_success" OK

        end
    end
```
### Example

This example demonstrates authenticating a user with username and password.

!!! example "User Login via WebSocket"

    **WebSocket Connection**
    ```javascript
    const wss = new WebSocket('wss://<your-server-address>/ws');
    ```

    **Request Message**
    ```json
    {
      "type": "login",
      "payload": {
        "username": "jane.doe",
        "password": "securePassword123"
      }
    }
    ```

    **Response Message (auth_success)**
    ```json
    {
      "type": "auth_success",
      "payload": {
        "username": "jane.doe",
        "token": "550e8400-e29b-41d4-a716-446655440000..."
      }
    }
    ```

    **Error Response (auth_error)**
    ```json
    {
      "type": "auth_error",
      "payload": {
        "message": "Invalid username or password"
      }
    }
    ```


