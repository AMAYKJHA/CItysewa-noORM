# CitySewa Landing Page - Component Reference

## 📋 Component Overview

### 1. **ThemeContext.jsx**
**Purpose**: Global theme management for light/dark mode

**Features**:
- Automatic system preference detection
- LocalStorage persistence
- Theme toggle function
- CSS variable updates

**Usage**:
```jsx
import { useTheme } from '../context/ThemeContext';

const MyComponent = () => {
  const { isDark, toggleTheme } = useTheme();
  return <button onClick={toggleTheme}>Toggle Theme</button>;
};
```

**Props/State**:
```typescript
interface ThemeContextType {
  isDark: boolean;
  toggleTheme: () => void;
}
```

---

### 2. **FeaturedServices.jsx**
**Purpose**: Carousel displaying featured services from API

**Props**: None (uses API directly)

**State**:
- `services`: Array of service objects
- `currentIndex`: Current carousel position
- `loading`: Loading state

**Features**:
- Auto-fetches services from `/api/v1/services/`
- Manual navigation (prev/next buttons)
- Dot navigation for quick jump
- Smooth transitions
- Responsive height

**API Endpoint Required**:
```
GET /api/v1/services/
Response: { results: [...] }
```

**Service Object Format**:
```json
{
  "id": 1,
  "name": "Electrical Repairs",
  "description": "Professional electrical services",
  "category": "Electrician"
}
```

---

### 3. **Reviews.jsx**
**Purpose**: Display customer testimonials and reviews

**Props**: None

**State**: None (hardcoded testimonials)

**Features**:
- Grid layout (1-4 columns responsive)
- Star ratings (emoji ⭐)
- Reviewer info with role
- Hover animations
- Responsive card sizing

**Current Data**:
```jsx
const testimonials = [
  {
    id: 1,
    name: 'Rajesh Kumar',
    role: 'Homeowner',
    text: 'Found a reliable electrician...',
    rating: 5,
  },
  // ... more testimonials
];
```

**To Connect Real Data**:
```jsx
const [reviews, setReviews] = useState([]);

useEffect(() => {
  const fetchReviews = async () => {
    const response = await fetch('/api/v1/reviews/');
    const data = await response.json();
    setReviews(data.results);
  };
  fetchReviews();
}, []);
```

---

### 4. **Stats.jsx**
**Purpose**: Display platform statistics and metrics

**Props**: None

**State**:
- `stats`: Object with metrics
  - `users`: Total users
  - `providers`: Service providers
  - `services`: Available services
  - `bookings`: Completed bookings

**Features**:
- Animated number display
- Gradient backgrounds
- Hover scale effect
- Responsive grid

**Current Data** (Sample):
```jsx
{
  users: 10500,
  providers: 2300,
  services: 450,
  bookings: 47000
}
```

**Display Format**:
- 10.5K+ (formatted with K/M suffix)
- Displayed with descriptive labels

---

### 5. **JoinUs.jsx**
**Purpose**: Call-to-action section with three role options

**Props**: None

**Features**:
- Three distinct cards (Provider, Customer, Developer)
- Icon decoration (emoji)
- Benefits list with checkmarks
- CTA buttons with distinct styling
- Hover animations

**Current Links**:
```jsx
Provider:   /register (generic)
Customer:   /register (generic)
Developer:  mailto:contact@citysewa.com (email)
```

**Customization Needed**:
- Update `/register` to `/register?type=provider` or similar
- Update email to `careers@citysewa.com` or your actual email
- Consider adding query parameters to pre-fill form type

**Card Properties**:
```jsx
{
  icon: string (emoji),
  title: string,
  description: string,
  benefits: string[],
  buttonText: string,
  buttonLink: string,
  buttonClass: string (provider-btn | customer-btn | dev-btn)
}
```

---

### 6. **Navbar.jsx** (Enhanced)
**Purpose**: Navigation with theme toggle

**New Features**:
- Theme toggle button (☀️/🌙)
- Uses `useTheme()` hook
- Integrated with responsive design
- Accessible with ARIA labels

**ThemeToggle Component**:
```jsx
const ThemeToggle = ({ isDark, toggleTheme }) => {
  return (
    <button 
      className='theme-toggle' 
      onClick={toggleTheme}
      aria-label="Toggle dark mode"
      title={isDark ? 'Switch to light mode' : 'Switch to dark mode'}
    >
      {isDark ? '☀️' : '🌙'}
    </button>
  );
};
```

**Props**:
- `isDark`: boolean (current theme)
- `toggleTheme`: function (toggle handler)

---

### 7. **Home.jsx**
**Purpose**: Main landing page orchestrator

**Structure**:
```jsx
<main className="home">
  <Hero />
  <FeaturedServices />
  <Reviews />
  <Stats />
  <JoinUs />
</main>
```

**Hero Component** (inline):
- Title: "Connect with Local Experts"
- Subtitle: "Find trusted service providers..."
- Two CTA buttons (Browse Services, Learn More)
- Gradient background

---

## 🎨 CSS Classes Reference

### Home Page Classes

```css
.home                          /* Main container */
.hero                          /* Hero section */
.hero-content                  /* Hero content wrapper */
.hero-title                    /* Hero main title */
.hero-subtitle                 /* Hero subheading */
.hero-cta                      /* CTA buttons container */

.featured-services             /* Carousel section */
.carousel-container            /* Carousel wrapper */
.carousel                      /* Carousel slides */
.service-card                  /* Individual service card */
.service-card.active           /* Active carousel slide */
.carousel-controls             /* Control buttons area */
.carousel-btn                  /* Navigation buttons */
.carousel-dots                 /* Dots container */
.dot                          /* Individual dot */
.dot.active                   /* Active dot */

.reviews-section               /* Reviews container */
.reviews-grid                  /* Grid layout */
.review-card                   /* Individual review */
.stars                         /* Star rating */
.review-text                   /* Review quote */
.reviewer-info                 /* Name and role */

.stats-section                 /* Statistics container */
.stats-grid                    /* Grid layout */
.stat-card                     /* Individual stat card */
.stat-number                   /* Number display */
.stat-label                    /* Label below number */

.join-us-section               /* Join section container */
.join-options                  /* Cards container */
.join-card                     /* Individual card */
.join-card.provider           /* Provider card variant */
.join-card.customer           /* Customer card variant */
.join-card.developer          /* Developer card variant */
.icon                         /* Emoji icon */
.benefits                     /* Benefits list */
.benefits li                  /* List item with checkmark */
.cta-btn                      /* CTA button */
```

### Navbar Classes

```css
nav                           /* Main navbar */
.nav-menu                     /* Menu items container */
.navItem                      /* Individual menu item */
.nav-logo-section             /* Logo area */
.siteLogo                     /* Site logo image */
.theme-toggle                 /* Theme toggle button */
.hamburger                    /* Mobile menu button */
.desktop-menu                 /* Desktop menu container */
.handheld-menu                /* Mobile menu container */
.handheld-menu.open           /* Mobile menu open state */
```

---

## 🎯 CSS Variables

### Theme Variables

```css
/* Light Mode */
--bg-primary: #ffffff;
--bg-secondary: #f8f9fa;
--text-primary: #1a1a1a;
--text-secondary: #666666;
--border-color: #e0e0e0;
--accent-color: #ff6b35;
--accent-light: #fff3f0;
--card-bg: #ffffff;
--card-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
--hover-bg: #f5f5f5;

/* Dark Mode */
--bg-primary: #1a1a1a;
--bg-secondary: #2d2d2d;
--text-primary: #ffffff;
--text-secondary: #b0b0b0;
--border-color: #404040;
--accent-color: #ff8a50;
--accent-light: #2a1a14;
--card-bg: #252525;
--card-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
--hover-bg: #333333;
```

---

## 📱 Responsive Breakpoints

```css
@media (max-width: 480px)   /* Mobile phones */
@media (max-width: 768px)   /* Tablets */
@media (max-width: 1024px)  /* Small desktops */
@media (min-width: 1024px)  /* Desktops */
@media (min-width: 1252px)  /* Large desktops */
```

---

## 🔗 Component Dependencies

```
App.jsx (ThemeProvider)
  ↓
Home.jsx
  ├── Hero (inline)
  ├── FeaturedServices.jsx
  │   └── (calls fetchServices from client.js)
  ├── Reviews.jsx
  │   └── (hardcoded data)
  ├── Stats.jsx
  │   └── (hardcoded data)
  └── JoinUs.jsx
      └── (Links to registration pages)

PublicLayout
  ├── Navbar.jsx
  │   └── ThemeContext hook
  ├── <Outlet /> (renders Home)
  └── Footer.jsx
```

---

## ⚙️ Configuration

### Environment Variables Needed
```env
VITE_API_URL=https://citysewa2.onrender.com/api/v1
```

### API Endpoints Used
```
GET /api/v1/services/          # Featured services
GET /api/v1/reviews/           # Reviews (optional)
GET /api/v1/statistics/        # Stats (optional)
POST /accounts/customer/register
POST /accounts/provider/register
```

---

## 🧪 Testing Tips

1. **Theme Testing**:
   - Click theme toggle button
   - Verify all sections change colors
   - Refresh page - theme should persist

2. **Carousel Testing**:
   - Click previous/next arrows
   - Click dots to jump
   - Verify smooth transitions

3. **Responsive Testing**:
   - Resize browser window
   - Test on multiple devices
   - Verify no horizontal scrolling

4. **Accessibility Testing**:
   - Tab through all interactive elements
   - Test with screen reader
   - Verify color contrast ratios

---

## 📦 Component Reusability

### Carousel Pattern
Can be reused for:
- Product showcase
- Team members display
- Case studies
- Testimonial rotation

### Card Pattern
Used in:
- Reviews
- Statistics
- Join Us options
- Future: Team members, services

### Theme System
Can apply to:
- Entire application
- Specific page sections
- Dynamic component themeing

---

**Last Updated**: February 15, 2026  
**Status**: Production Ready
