import './App.css';
import React from 'react';
import Home from './Home';
import Header from './Header';
import Add from './Add';
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";

function App() {
  return (
    <div className="App">
      <Router>
      <Header />
      <Home />
      <Routes>
        <Route path="/Add" element={<Add />} />
      </Routes>
      </Router>
    </div>
  );
}

export default App;
