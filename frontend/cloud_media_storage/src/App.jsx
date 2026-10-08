import { useEffect, useState } from "react";
import MessageBox from "./components/MessageBox";

// function App() {
//   const [message, setMessage] = useState("");

//   useEffect(() => {
//     fetch("http://127.0.0.1:8000/api/hello/")
//       .then((response) => response.json())
//       .then((data) => setMessage(data.message));
//   }, []);

//   return <h1>{message}</h1>;
// }

// export default App;


function App() {
  return (
    <div>
      <h1>Chat</h1>

      <MessageBox />
    </div>
  );
}

export default App;