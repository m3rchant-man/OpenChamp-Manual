---
tags:
  - Chat-Endpoints
---

This endpoint broadcasts a message to all connected players in the OpenChampPS instance via WebSocket connection.

### Request

`WebSocket Endpoint: /ws`

**Message Type:** `global_chat`

---

### Input Schema


#### Message Structure

| Field     | Type   | Description                                     | Required |
| :-------- | :----- | :---------------------------------------        | :------- |
| `type`    | String | Must be `global_chat` for global chat messages. | Yes      |
| `payload` | String | The message content to broadcast.               | Yes      |

---

### Output Schema

#### Response Message (`global_chat`)

| Field     | Type   | Description                                    |
| :-------- | :----- | :--------------------------------------------- |
| `type`    | String | Will be `global_chat` for broadcast messages.  |
| `payload` | Object | Contains the sender and message details.       |

#### Payload Fields

| Field      | Type   | Description                                    |
| :--------- | :----- | :--------------------------------------------- |
| `username` | String | The username of the message sender.            |
| `message`  | String | The message content that was broadcast.        |

---

### Error Responses

#### Error Codes


| Message Type   | Error Code/Message              | Description                                        |
| :------------- | :------------------------------ | :----------------------------------------------    |
| `error`        | `AUTH_REQUIRED`                 | User must be authenticated before sending global chat messages. |

---

### Sequence Diagram
```mermaid
sequenceDiagram
    participant C1 as Client 1 (Sender)
    participant S as OpenChampPS
    participant M as ClientManager
    participant C2 as Client 2 (Receiver)
    participant C3 as Client 3 (Receiver)

    C1->>S: 1. Global Chat Message Request
    activate S
    
    S->>S: Verify authentication (Stateful Session)
    
    alt Not Authenticated
        S-->>C1: 2. "error" Authentication required
    else Authenticated
        S->>S: 2. Construct broadcast message (Include username)
        
        S->>M: 3. Send message to broadcast channel
        activate M
        M->>C1: 4. Broadcast to Client 1 (Self)
        M->>C2: 4. Broadcast to Client 2
        M->>C3: 4. Broadcast to Client 3
        Note over M: Message sent to ALL connected clients
        deactivate M
        
        deactivate S
    end
```
### Example

This example demonstrates sending a message to all connected players via global chat.

!!! example "Send Global Chat Message via WebSocket"

    **WebSocket Connection**
    ```javascript
    const ws = new WebSocket('ws://<your-server-address>/ws');
    ```

    **Request Message**
    ```json
    {
      "type": "global_chat",
      "payload": "Hello everyone!"
    }
    ```

    **Response Message (global_chat) - Broadcast to All Clients**
    ```json
    {
      "type": "global_chat",
      "payload": {
        "username": "jane.doe",
        "message": "Hello everyone!"
      }
    }
    ```

    **Error Response (Authentication Required)**
    ```json
    {
      "type": "error",
      "payload": {
        "message": "Authentication required",
        "code": "AUTH_REQUIRED"
      }
    }
    ```