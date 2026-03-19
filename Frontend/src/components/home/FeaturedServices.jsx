import { useState, useEffect, useRef } from 'react';
import { fetchServices } from '../../api/client';
import '../../Style/Home.css';

const FeaturedServices = () => {
  const [services, setServices] = useState([]);
  const [grouped, setGrouped] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(1);
  const [transition, setTransition] = useState(true);
  const [visibleCards, setVisibleCards] = useState(3);
  const [loading, setLoading] = useState(true);

  const trackRef = useRef(null);
  const startX = useRef(0);
  const isDragging = useRef(false);
  const autoplayRef = useRef(null);

  useEffect(() => {
    const update = () => {
      if (window.innerWidth < 600) setVisibleCards(1);
      else if (window.innerWidth < 900) setVisibleCards(2);
      else setVisibleCards(3);
    };

    update();
    window.addEventListener('resize', update);
    return () => window.removeEventListener('resize', update);
  }, []);

  useEffect(() => {
    const getServices = async () => {
      try {
        const res = await fetchServices();
        const data = res.data?.slice(0, 6) || [];
        setServices(data);
      } catch (e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    };
    getServices();
  }, []);

  const chunk = (arr, size) => {
    const res = [];
    for (let i = 0; i < arr.length; i += size) {
      res.push(arr.slice(i, i + size));
    }
    return res;
  };

  useEffect(() => {
    if (!services.length) return;

    const groups = chunk(services, visibleCards);

    const slides = [
      groups[groups.length - 1],
      ...groups,
      groups[0],
    ];

    setGrouped(slides);
    setCurrentIndex(1);
  }, [services, visibleCards]);

  const nextSlide = () => {
    if (!transition) return;
    setCurrentIndex((prev) => prev + 1);
  };

  const prevSlide = () => {
    if (!transition) return;
    setCurrentIndex((prev) => prev - 1);
  };

  useEffect(() => {
    const handleEnd = () => {
      if (currentIndex === grouped.length - 1) {
        setTransition(false);
        setCurrentIndex(1);
      }
      if (currentIndex === 0) {
        setTransition(false);
        setCurrentIndex(grouped.length - 2);
      }
    };

    const track = trackRef.current;
    track?.addEventListener('transitionend', handleEnd);
    return () => track?.removeEventListener('transitionend', handleEnd);
  }, [currentIndex, grouped]);

  useEffect(() => {
    if (!transition) {
      requestAnimationFrame(() => setTransition(true));
    }
  }, [transition]);

  useEffect(() => {
    autoplayRef.current = setInterval(nextSlide, 3000);
    return () => clearInterval(autoplayRef.current);
  }, []);

  const pauseAuto = () => clearInterval(autoplayRef.current);
  const resumeAuto = () => {
    clearInterval(autoplayRef.current);
    autoplayRef.current = setInterval(nextSlide, 3000);
  };

  const handleStart = (e) => {
    isDragging.current = true;
    startX.current = e.touches ? e.touches[0].clientX : e.clientX;
  };

  const handleMove = (e) => {
    if (!isDragging.current) return;
    const currentX = e.touches ? e.touches[0].clientX : e.clientX;
    const diff = startX.current - currentX;

    if (diff > 50) {
      nextSlide();
      isDragging.current = false;
    } else if (diff < -50) {
      prevSlide();
      isDragging.current = false;
    }
  };

  const handleEnd = () => {
    isDragging.current = false;
  };

  if (loading) return <p className="center">Loading...</p>;
  if (!grouped.length) return <p className="center">No services</p>;

  return (
    <section className="featured-services">
      <h2>Featured Services</h2>
      <div
        className="carousel-wrapper"
        onMouseEnter={pauseAuto}
        onMouseLeave={resumeAuto}
        onMouseDown={handleStart}
        onMouseMove={handleMove}
        onMouseUp={handleEnd}
        onTouchStart={handleStart}
        onTouchMove={handleMove}
        onTouchEnd={handleEnd}
      >
        <button className="carousel-btn left" onClick={prevSlide}>❮</button>
        <div className="carousel">
          <div
            ref={trackRef}
            className="carousel-track"
            style={{
              transform: `translateX(-${currentIndex * 100}%)`,
              transition: transition ? '0.5s ease' : 'none',
            }}
          >
            {grouped.map((group, i) => (
              <div className="slide" key={i}>
                {group.map((s, idx) => (
                  <div className="service-card" key={idx}>
                    <img src={s.thumbnail || '/placeholder.png'} alt={s.title} />
                    <h3>{s.title}</h3>
                    <p>{s.description}</p>
                    <span>Rs. {s.price}</span>
                  </div>
                ))}
              </div>
            ))}
          </div>
        </div>
        <button className="carousel-btn right" onClick={nextSlide}>❯</button>
        <div className="dots">
          {grouped.slice(1, -1).map((_, i) => (
            <span
              key={i}
              className={currentIndex === i + 1 ? 'active' : ''}
              onClick={() => setCurrentIndex(i + 1)}
            />
          ))}
        </div>
      </div>
    </section>
  );
};

export default FeaturedServices;