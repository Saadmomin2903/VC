# Augment Website

The official website for Augment - Intelligent File Versioning for macOS.

## 🚀 Features

- **Modern Next.js 13+ with App Router** - Latest Next.js features and performance optimizations
- **Responsive Design** - Mobile-first approach with beautiful UI across all devices
- **Dark Mode Support** - Automatic theme switching with system preference detection
- **SEO Optimized** - Comprehensive meta tags, structured data, and performance optimization
- **Accessibility First** - ARIA labels, keyboard navigation, and screen reader support
- **TypeScript** - Full type safety throughout the application
- **Tailwind CSS** - Utility-first CSS framework with custom design system
- **Framer Motion** - Smooth animations and transitions
- **Component Library** - Reusable, well-documented components

## 📁 Project Structure

```
website/
├── src/
│   ├── app/                    # Next.js 13+ App Router pages
│   │   ├── about/             # About page
│   │   ├── documentation/     # Documentation section
│   │   ├── download/          # Download page
│   │   ├── features/          # Features page
│   │   ├── support/           # Support page
│   │   ├── layout.tsx         # Root layout
│   │   ├── page.tsx           # Homepage
│   │   └── globals.css        # Global styles
│   ├── components/            # Reusable components
│   │   ├── about/            # About page components
│   │   ├── documentation/    # Documentation components
│   │   ├── download/         # Download page components
│   │   ├── features/         # Features page components
│   │   ├── support/          # Support page components
│   │   ├── navigation.tsx    # Main navigation
│   │   ├── footer.tsx        # Site footer
│   │   └── ...               # Other shared components
│   ├── lib/                  # Utility functions
│   ├── types/                # TypeScript type definitions
│   └── data/                 # Static data and content
├── public/                   # Static assets
├── package.json             # Dependencies and scripts
├── tailwind.config.js       # Tailwind CSS configuration
├── tsconfig.json           # TypeScript configuration
└── next.config.js          # Next.js configuration
```

## 🛠️ Development

### Prerequisites

- Node.js 18+ 
- npm or yarn or pnpm

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd website
```

2. Install dependencies:
```bash
npm install
# or
yarn install
# or
pnpm install
```

3. Start the development server:
```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

4. Open [http://localhost:3000](http://localhost:3000) in your browser.

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npm run type-check` - Run TypeScript type checking

## 🎨 Design System

### Colors

The website uses a carefully crafted color palette:

- **Primary**: Blue (#3b82f6) - Used for CTAs, links, and brand elements
- **Secondary**: Gray scale - For text, backgrounds, and UI elements
- **Accent**: Purple (#d946ef) - For highlights and gradients

### Typography

- **Headings**: Inter font family with various weights
- **Body**: Inter font family, optimized for readability
- **Code**: JetBrains Mono for code snippets and technical content

### Components

All components follow consistent patterns:

- **Responsive by default** - Mobile-first approach
- **Accessible** - ARIA labels and keyboard navigation
- **Themeable** - Support for light and dark modes
- **Reusable** - Well-documented props and variants

## 📱 Pages Overview

### Homepage (`/`)
- Hero section with value proposition
- Feature highlights
- How it works explanation
- User testimonials
- Call-to-action sections

### Features (`/features`)
- Comprehensive feature breakdown
- Interactive demonstrations
- Feature comparisons
- Technical specifications

### Download (`/download`)
- Download options for different platforms
- System requirements
- Installation instructions
- FAQ section

### Documentation (`/documentation`)
- Complete user guide
- Getting started tutorials
- Advanced feature explanations
- Troubleshooting guides
- API reference

### About (`/about`)
- Company mission and values
- Team information
- Development timeline
- Contact information

### Support (`/support`)
- Help resources
- Contact forms
- Community links
- FAQ section

## 🔧 Configuration

### Environment Variables

Create a `.env.local` file in the root directory:

```env
NEXT_PUBLIC_GA_ID=your-google-analytics-id
NEXT_PUBLIC_SITE_URL=https://augment-app.com
```

### SEO Configuration

SEO settings are configured in each page's metadata:

```typescript
export const metadata: Metadata = {
  title: 'Page Title',
  description: 'Page description',
  // ... other SEO settings
}
```

### Analytics

The website includes Google Analytics integration. Set your GA ID in the environment variables.

## 🚀 Deployment

### Vercel (Recommended)

1. Connect your repository to Vercel
2. Set environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### Other Platforms

The website can be deployed to any platform that supports Next.js:

- Netlify
- AWS Amplify
- Railway
- DigitalOcean App Platform

Build command: `npm run build`
Output directory: `.next`

## 🧪 Testing

### Manual Testing Checklist

- [ ] All pages load correctly
- [ ] Navigation works on all devices
- [ ] Forms submit properly
- [ ] Dark mode toggles correctly
- [ ] Images load and are optimized
- [ ] SEO meta tags are present
- [ ] Accessibility features work

### Performance

The website is optimized for performance:

- **Image Optimization** - Next.js automatic image optimization
- **Code Splitting** - Automatic code splitting by Next.js
- **Static Generation** - Pages are statically generated where possible
- **Font Optimization** - Google Fonts are optimized and preloaded

## 📄 Content Management

### Adding New Pages

1. Create a new directory in `src/app/`
2. Add `page.tsx` with the page component
3. Update navigation in `src/components/navigation.tsx`
4. Add appropriate metadata for SEO

### Updating Content

Most content is stored in components and can be updated directly in the code. For larger content updates, consider implementing a headless CMS.

### Documentation

Documentation content is structured in the `src/components/documentation/` directory. Each section has its own component for easy maintenance.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Style

- Use TypeScript for all new code
- Follow the existing component patterns
- Use Tailwind CSS for styling
- Add proper TypeScript types
- Include accessibility features

## 📞 Support

For questions about the website:

- Create an issue in the repository
- Contact the development team
- Check the documentation

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Built with ❤️ for the Augment community.
