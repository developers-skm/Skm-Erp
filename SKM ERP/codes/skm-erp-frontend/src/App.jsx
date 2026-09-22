import LoginPage from './components/LoginPage'

function App() {
  function handleLogin({ username, password, remember }) {
    // TODO: wire this up to the real authentication API
    console.log('Login attempt:', { username, password, remember })
    alert(`Welcome, ${username}! (login wiring pending)`)
  }

  return <LoginPage onLogin={handleLogin} />
}

export default App
