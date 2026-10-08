import { useState } from "react";

function MessageBox() {
  const [message, setMessage] = useState("");

  const sendMessage = async () => {
    try {
      const response = await fetch(
        "http://127.0.0.1:8000/api/message/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            userType: "user",
            message: message,
          }),
        }
      );

      if (!response.ok) {
        throw new Error(`HTTP error: ${response.status}`);
      }

      const data = await response.json();

      console.log("Django response:", data);
    } catch (error) {
      console.error("Request failed:", error);
    }
  };

  return (
    <div>
      <input
        type="text"
        placeholder="Type your message"
        value={message}
        onChange={(e) => setMessage(e.target.value)}
      />

      <button onClick={sendMessage}>
        Send
      </button>

      <p>You typed: {message}</p>
    </div>
  );
}

export default MessageBox;