import { useState } from 'react'
import './LoginPage.css'

export default function LoginPage({ onLogin }) {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [remember, setRemember] = useState(false)
  const [error, setError] = useState('')

  function handleSubmit(e) {
    e.preventDefault()
    setError('')

    if (!username.trim() || !password.trim()) {
      setError('Please enter both username and password.')
      return
    }

    onLogin?.({ username, password, remember })
  }

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-brand">
          <div className="login-logo" aria-hidden="true">
            <svg viewBox="0 0 64 64" width="40" height="40">
              <ellipse cx="32" cy="40" rx="20" ry="18" fill="#F2A93B" />
              <circle cx="42" cy="24" r="14" fill="#FBC85A" />
              <circle cx="47" cy="19" r="2.4" fill="#3A2C1D" />
              <path d="M54 22 L61 19 L55 27 Z" fill="#E2521B" />
              <path d="M40 12 L44 4 L47 13 Z" fill="#E2521B" />
              <path d="M46 12 L49 3 L52 13 Z" fill="#E2521B" />
            </svg>
          </div>
          <h1>SKM ERP</h1>
          <p className="login-subtitle">Hen Farm Management System</p>
        </div>

        <form className="login-form" onSubmit={handleSubmit} noValidate>
          <label className="field">
            <span className="field-label">Username</span>
            <div className="field-input">
              <span className="field-icon" aria-hidden="true">👤</span>
              <input
                type="text"
                name="username"
                placeholder="Enter your username"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                autoComplete="username"
              />
            </div>
          </label>

          <label className="field">
            <span className="field-label">Password</span>
            <div className="field-input">
              <span className="field-icon" aria-hidden="true">🔒</span>
              <input
                type={showPassword ? 'text' : 'password'}
                name="password"
                placeholder="Enter your password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                autoComplete="current-password"
              />
              <button
                type="button"
                className="toggle-visibility"
                onClick={() => setShowPassword((v) => !v)}
                aria-label={showPassword ? 'Hide password' : 'Show password'}
              >
                {showPassword ? '🙈' : '👁️'}
              </button>
            </div>
          </label>

          <div className="field-row">
            <label className="remember">
              <input
                type="checkbox"
                checked={remember}
                onChange={(e) => setRemember(e.target.checked)}
              />
              Remember me
            </label>
            <a href="#forgot-password" className="forgot-link">
              Forgot password?
            </a>
          </div>

          {error && <div className="login-error">{error}</div>}

          <button type="submit" className="login-button">
            Log In
          </button>
        </form>

        <p className="login-footer">
          &copy; {new Date().getFullYear()} SKM ERP &mdash; Farm Operations Suite
        </p>
      </div>
    </div>
  )
}
