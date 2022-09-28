import './App.css';
import React from 'react';
import Home from './Home';
import Header from './Header';
import Add from './Add';
import View from './View';
import Quiz from './Quiz';
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";

function App() {
  return (
    <div className="App">
      <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/Add" element={<Add />} />
        <Route path="/View" element={<View />} />
        <Route path="/Quiz" element={<Quiz />} />
      </Routes>
      </Router>
    </div>
  );
}

export default App;