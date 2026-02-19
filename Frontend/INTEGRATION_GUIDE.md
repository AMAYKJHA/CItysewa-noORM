# CitySewa Landing Page - Code Examples & Integration Guide

## 🔗 Connecting Real Data

### 1. Fetch Services for Carousel

**Current Implementation** (FeaturedServices.jsx):
```jsx
const getServices = async () => {
    try {
        const response = await fetchServices();
        const featured = response.data?.results?.slice(0, 6) || [];
        setServices(featured);
    } catch (error) {
        console.error('Failed to fetch services:', error);
    }
};
```

**Expected API Response Format**:
```json
{
  "results": [
    {
      "id": 1,
      "name": "Electrical Repairs",
      "description": "Professional electrical services for homes and offices",
      "category": "Electrician"
    },
    {
      "id": 2,
      "name": "Plumbing Services",
      "description": "Complete plumbing solutions",
      "category": "Plumber"
    }
  ]
}
```

### 2. Add Real Reviews

**Update Reviews.jsx**:
```jsx
const [reviews, setReviews] = useState([]);

useEffect(() => {
    const fetchReviews = async () => {
        try {
            const response = await fetch('/api/v1/reviews/');
            const data = await response.json();
            setReviews(data.results || []);
        } catch (error) {
            console.error('Error fetching reviews:', error);
        }
    };
    fetchReviews();
}, []);

return (
    <div className="reviews-grid">
        {reviews.map((review) => (
            <div key={review.id} className="review-card">
                <div className="stars">
                    {'⭐'.repeat(review.rating)}
                </div>
                <p className="review-text">"{review.text}"</p>
                <div className="reviewer-info">
                    <h4>{review.name}</h4>
                    <p className="reviewer-role">{review.role}</p>
                </div>
            </div>
        ))}
    </div>
);
```

### 3. Update Statistics with Real Data

**Update Stats.jsx**:
```jsx
useEffect(() => {
    const fetchStats = async () => {
        try {
            const statsResponse = await fetch('/api/v1/statistics/');
            const data = await statsResponse.json();
            setStats({
                users: data.total_users || 0,
                providers: data.total_providers || 0,
                services: data.total_services || 0,
                bookings: data.total_bookings || 0
            });
        } catch (error) {
            console.error('Error fetching stats:', error);
        }
    };
    fetchStats();
}, []);
```

### 4. Connect CTAs to Correct Routes

**Update JoinUs.jsx**:
```jsx
import { useNavigate } from 'react-router-dom';

const JoinUs = () => {
    const navigate = useNavigate();

    return (
        <div className="join-options">
            <div className="join-card provider">
                <div className="icon">🔧</div>
                <h3>Become a Provider</h3>
                <p>Grow your service business...</p>
                <button 
                    onClick={() => navigate('/register?type=provider')}
                    className="cta-btn provider-btn"
                >
                    Join as Provider
                </button>
            </div>

            <div className="join-card customer">
                <div className="icon">👤</div>
                <h3>Become a Customer</h3>
                <p>Find trusted local experts...</p>
                <button 
                    onClick={() => navigate('/register?type=customer')}
                    className="cta-btn customer-btn"
                >
                    Join as Customer
                </button>
            </div>

            <div className="join-card developer">
                <div className="icon">💻</div>
                <h3>Join Development Team</h3>
                <p>Help us build the next generation...</p>
                <a 
                    href="mailto:careers@citysewa.com?subject=Development%20Team%20Interest"
                    className="cta-btn dev-btn"
                >
                    Contact Us
                </a>
            </div>
        </div>
    );
};
```

## 🎨 Customizing Theme Colors

**Edit theme variables in Home.css**:

```css
:root[data-theme="light"] {
    --bg-primary: #ffffff;          /* Main background */
    --bg-secondary: #f8f9fa;        /* Section backgrounds */
    --text-primary: #1a1a1a;        /* Headings, main text */
    --text-secondary: #666666;      /* Body text, labels */
    --border-color: #e0e0e0;        /* Borders */
    --accent-color: #ff6b35;        /* Primary action color */
    --accent-light: #fff3f0;        /* Light accent backgrounds */
    --card-bg: #ffffff;             /* Card backgrounds */
    --card-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    --hover-bg: #f5f5f5;            /* Hover state background */
}

:root[data-theme="dark"] {
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
}
```

## 🔄 Managing Theme State

**Using Theme in Components**:

```jsx
import { useTheme } from '../context/ThemeContext';

export const MyComponent = () => {
    const { isDark, toggleTheme } = useTheme();

    return (
        <div>
            <p>Current theme: {isDark ? 'Dark' : 'Light'}</p>
            <button onClick={toggleTheme}>
                Switch to {isDark ? 'Light' : 'Dark'} mode
            </button>
        </div>
    );
};
```

**Programmatically Check Theme**:

```jsx
const isDarkMode = localStorage.getItem('theme') === 'dark';
const prefersLight = window.matchMedia('(prefers-color-scheme: light)').matches;
```

## 🎬 Enhancing the Carousel

**Add Auto-rotation**:

```jsx
useEffect(() => {
    const interval = setInterval(() => {
        nextSlide();
    }, 5000); // Auto-rotate every 5 seconds

    return () => clearInterval(interval);
}, [services.length]);
```

**Add Keyboard Navigation**:

```jsx
useEffect(() => {
    const handleKeyDown = (e) => {
        if (e.key === 'ArrowLeft') prevSlide();
        if (e.key === 'ArrowRight') nextSlide();
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
}, []);
```

**Add Touch Swipe Support**:

```jsx
const [touchStart, setTouchStart] = useState(0);
const [touchEnd, setTouchEnd] = useState(0);

const handleTouchStart = (e) => setTouchStart(e.targetTouches[0].clientX);
const handleTouchEnd = (e) => {
    setTouchEnd(e.changedTouches[0].clientX);
    handleSwipe();
};

const handleSwipe = () => {
    if (touchStart - touchEnd > 50) nextSlide();
    if (touchEnd - touchStart > 50) prevSlide();
};

// In JSX:
<div 
    className="carousel"
    onTouchStart={handleTouchStart}
    onTouchEnd={handleTouchEnd}
>
    {/* Carousel content */}
</div>
```

## 📊 Analytics Integration

**Add Google Analytics**:

```jsx
import { useEffect } from 'react';

const usePageTracking = () => {
    useEffect(() => {
        // Track page view
        window.gtag('config', 'GA_ID', {
            page_path: window.location.pathname,
            page_title: document.title,
        });
    }, []);
};

// Track CTA clicks
const trackCTAClick = (category) => {
    window.gtag('event', 'signup', {
        'category': category, // 'provider', 'customer', 'developer'
        'timestamp': new Date()
    });
};
```

## 🏗️ Adding New Sections

**Template for Adding a Section**:

```jsx
// src/components/home/NewSection.jsx
import '../../Style/Home.css';

const NewSection = () => {
    return (
        <section className="new-section">
            <h2>Section Title</h2>
            <p className="subtitle">Section subtitle</p>
            
            {/* Your content here */}
        </section>
    );
};

export default NewSection;
```

**Add to Home.jsx**:

```jsx
import NewSection from '../components/home/NewSection';

const Home = () => {
    return (
        <main className="home">
            <Hero />
            <FeaturedServices />
            <Reviews />
            <Stats />
            <NewSection />  {/* Add here */}
            <JoinUs />
        </main>
    );
};
```

**Add CSS styling in Home.css**:

```css
.new-section {
    padding: 80px 20px;
    background-color: var(--bg-primary);
    text-align: center;
}

@media (max-width: 768px) {
    .new-section {
        padding: 50px 15px;
    }
}
```

## 🔐 Environment Variables

**Create .env file**:

```env
VITE_API_URL=https://your-api-domain.com/api/v1
VITE_GA_ID=your-google-analytics-id
VITE_CONTACT_EMAIL=contact@citysewa.com
```

**Use in code**:

```jsx
const API_URL = import.meta.env.VITE_API_URL;

const fetchServices = async () => {
    const response = await fetch(`${API_URL}/services/`);
    return response.json();
};
```

## 🧪 Testing Your Changes

**Test Theme Switching**:
```js
// In browser console
localStorage.setItem('theme', 'dark');
document.documentElement.setAttribute('data-theme', 'dark');
// Page should immediately switch to dark mode
```

**Test API Integration**:
```js
// In browser console
fetch('https://your-api/services/')
    .then(r => r.json())
    .then(d => console.log(d))
```

## 📱 Mobile Testing

Use Chrome DevTools:
1. Press F12 to open Developer Tools
2. Click the device toggle icon (top-left)
3. Select device presets (iPhone, iPad, etc.)
4. Rotate device to test landscape

## 🚀 Deployment Checklist

- [ ] All API endpoints configured
- [ ] Environment variables set
- [ ] Dark mode tested thoroughly
- [ ] Responsive design verified on mobile
- [ ] All links working
- [ ] Form submissions working
- [ ] Analytics integrated
- [ ] Performance optimized
- [ ] SEO meta tags added
- [ ] Security headers configured

---

**Ready to deploy!** 🎉
