const express = require('express');
const cors = require('cors');

const PORT = process.env.PORT || 3000;

const menus = {
  pizza: ['Margherita Pizza', 'Pepperoni Pizza', 'BBQ Chicken Pizza', 'Calzone', 'Garlic Bread'],
  burger: ['Classic Burger', 'Cheese Burger', 'Double Smash Burger', 'Crispy Chicken Burger', 'Veggie Burger'],
  chicken: ['Grilled Chicken', 'Fried Chicken', 'Chicken Shawarma', 'Chicken Wings', 'Chicken Strips'],
  shawarma: ['Chicken Shawarma', 'Meat Shawarma', 'Mix Shawarma', 'Shawarma Plate', 'Grilled Kofta'],
  seafood: ['Grilled Fish', 'Fried Shrimp', 'Calamari', 'Fish & Chips', 'Seafood Platter'],
  egyptian: ['Koshary', 'Ful Medames', "Ta'meya", 'Molokhia', 'Hawawshi', 'Feteer'],
  sushi: ['California Roll', 'Salmon Sashimi', 'Dragon Roll', 'Miso Soup', 'Edamame'],
  sandwich: ['Club Sandwich', 'BLT', 'Tuna Sandwich', 'Grilled Cheese', 'Falafel Wrap'],
  kebab: ['Chicken Kebab', 'Kofta', 'Mixed Grill', 'Lamb Chops', 'Kebab Plate'],
  pasta: ['Spaghetti Bolognese', 'Fettuccine Alfredo', 'Penne Arrabbiata', 'Lasagna', 'Carbonara'],
  indian: ['Butter Chicken', 'Chicken Biryani', 'Garlic Naan', 'Dal Makhani', 'Samosa'],
  coffee: ['Espresso', 'Cappuccino', 'Latte', 'Iced Coffee', 'Cheesecake Slice'],
  steak: ['Ribeye Steak', 'Sirloin Steak', 'Grilled Lamb', 'Fillet Steak', 'Mixed Grill'],
  'fast food': ['Classic Burger', 'Fried Chicken', 'French Fries', 'Onion Rings', 'Milkshake'],
};

const defaultMenu = [
  'House Special',
  'Grilled Chicken',
  'Mixed Salad',
  'Soup of the Day',
  "Chef's Pasta",
];

const restaurants = [
  { id: '1', name: 'KFC Tahrir', cuisine: 'chicken', lat: 30.0444, lng: 31.2357 },
  { id: '2', name: "McDonald's Zamalek", cuisine: 'burger', lat: 30.0626, lng: 31.2198 },
  { id: '3', name: 'Pizza Hut Mohandeseen', cuisine: 'pizza', lat: 30.0596, lng: 31.2022 },
  { id: '4', name: "Hardee's Heliopolis", cuisine: 'burger', lat: 30.0884, lng: 31.3219 },
  { id: '5', name: 'Koshary El Tahrir', cuisine: 'egyptian', lat: 30.0451, lng: 31.2371 },
  { id: '6', name: 'Sushiway Cairo', cuisine: 'sushi', lat: 30.0701, lng: 31.3462 },
  { id: '7', name: 'Burger King Downtown', cuisine: 'burger', lat: 30.051, lng: 31.238 },
  { id: '8', name: 'Shawarmer Nasr City', cuisine: 'shawarma', lat: 30.06, lng: 31.33 },
  { id: '9', name: 'Fish & Chips Giza', cuisine: 'seafood', lat: 30.013, lng: 31.2085 },
  { id: '10', name: 'Cilantro Cafe Zamalek', cuisine: 'coffee', lat: 30.0571, lng: 31.2168 },
  { id: '11', name: 'Roadhouse Grill', cuisine: 'steak', lat: 30.0596, lng: 31.2234 },
  { id: '12', name: 'Maharaja Indian', cuisine: 'indian', lat: 30.056, lng: 31.215 },
  { id: '13', name: 'Kebabgy Mohandeseen', cuisine: 'kebab', lat: 30.058, lng: 31.2 },
];

function menuFor(cuisine) {
  const c = (cuisine || '').toLowerCase();
  for (const key of Object.keys(menus)) {
    if (c.includes(key)) return menus[key];
  }
  return defaultMenu;
}

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/restaurants', (req, res) => {
  res.json({ restaurants });
});

app.get('/api/restaurants/:id/products', (req, res) => {
  const r = restaurants.find((x) => x.id === req.params.id);
  if (!r) {
    res.status(404).json({ error: 'Restaurant not found' });
    return;
  }
  const items = menuFor(r.cuisine);
  const products = items.map((name, i) => ({
    id: `${r.id}_${i}`,
    name,
  }));
  res.json({ products });
});

app.get('/api/search', (req, res) => {
  const q = String(req.query.product || req.query.q || '').toLowerCase().trim();
  if (!q) {
    res.json({ restaurants: [] });
    return;
  }
  const matched = restaurants.filter((r) =>
    menuFor(r.cuisine).some((item) => item.toLowerCase().includes(q)),
  );
  res.json({ restaurants: matched });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Restaurant API listening on http://localhost:${PORT}`);
});
