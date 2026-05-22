---
name: Liquid Glass
colors:
  surface: '#121317'
  surface-dim: '#121317'
  surface-bright: '#38393d'
  surface-container-lowest: '#0d0e12'
  surface-container-low: '#1a1b20'
  surface-container: '#1e1f24'
  surface-container-high: '#292a2e'
  surface-container-highest: '#343439'
  on-surface: '#e3e2e7'
  on-surface-variant: '#c4c7c8'
  inverse-surface: '#e3e2e7'
  inverse-on-surface: '#2f3035'
  outline: '#8e9192'
  outline-variant: '#444748'
  surface-tint: '#c6c6c7'
  primary: '#ffffff'
  on-primary: '#2f3131'
  primary-container: '#e2e2e2'
  on-primary-container: '#636565'
  inverse-primary: '#5d5f5f'
  secondary: '#c8c6c5'
  on-secondary: '#303030'
  secondary-container: '#474746'
  on-secondary-container: '#b6b5b4'
  tertiary: '#ffffff'
  on-tertiary: '#2f3131'
  tertiary-container: '#e2e2e2'
  on-tertiary-container: '#636565'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e2e2e2'
  primary-fixed-dim: '#c6c6c7'
  on-primary-fixed: '#1a1c1c'
  on-primary-fixed-variant: '#454747'
  secondary-fixed: '#e4e2e1'
  secondary-fixed-dim: '#c8c6c5'
  on-secondary-fixed: '#1b1c1b'
  on-secondary-fixed-variant: '#474746'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c7'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#121317'
  on-background: '#e3e2e7'
  surface-variant: '#343439'
  glass-fill: rgba(255, 255, 255, 0.1)
  glass-edge: rgba(255, 255, 255, 0.2)
  shadow-3d: '#343539'
  completed-fill: rgba(0, 0, 0, 0.4)
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-sm:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  stack-gap: 12px
  gutter: 16px
  margin-mobile: 20px
  margin-tablet: 40px
  3d-offset-sm: 3px
  3d-offset-lg: 6px
---

## Brand & Style

Liquid Glass is a high-fidelity, futuristic design system that blends **Glassmorphism** with **Tactile / Skeuomorphic** depth. It is designed for focus-oriented productivity applications that want to feel premium, immersive, and physically reactive.

The aesthetic centers on "heavy" glass: surfaces have significant backdrop blurs (40px) and a sense of physical weight through 3D offsets. The interface responds to user interaction with physical compression, mimicking the tactile feel of pressing a physical button into a soft substrate. It evokes a professional yet cutting-edge emotional response, suitable for high-end developer tools or elite task management.

## Colors

The palette is monochromatic and sophisticated, relying on the interplay of light and transparency rather than hue.

- **Primary & Secondary:** Pure white (#FFFFFF) is used for high-emphasis text and active states. Secondary grey (#C8C6C5) handles lower-priority information and completed states.
- **Surface:** The background is not a flat color but a deep radial gradient starting from a dark slate (#292A2E) at the top center, fading into a near-black (#121317).
- **The "Liquid" Effect:** Surfaces are rendered using a semi-transparent white wash (10% opacity) combined with intense backdrop blurring.
- **The "Edge" Effect:** A high-contrast, low-thickness top border (20% white) creates a "specular highlight" on the top edge of every component, reinforcing the glass metaphor.

## Typography

The system uses **Hanken Grotesk** as the primary typeface for its sharp, contemporary geometry. Heavy weights (700-800) are used for titles and card labels to maintain legibility against blurred backgrounds.

**JetBrains Mono** is utilized as a secondary functional typeface for metadata, time stamps, and labels, providing a technical, precise contrast to the humanist headlines. Large display sizes use tight letter-spacing to emphasize the "bold" personality of the brand.

## Layout & Spacing

The layout follows a **Fixed Grid** approach for mobile (max-width: 448px) and a fluid center-aligned column for larger screens.

Spacing is governed by a strict 8px base unit. Component internal padding is typically 16px (2 units). A unique "stack-gap" of 12px is used between vertical list items to allow the 3D shadows room to breathe.

Three-dimensional offsets are critical: active components are visually raised by 6px. On click/press, components translate 3px downward, and on "completed" or "selected" states, they sit flush (0px offset) with the background.

## Elevation & Depth

Elevation is not achieved through traditional ambient shadows, but through **3D Layering and Backdrop Blurring**:

1. **The Base Shadow:** A pseudo-element creates a solid "extrusion" (#343539) behind components, giving them physical thickness.
2. **The Glass Layer:** The main component body uses a `backdrop-filter: blur(40px)` and a semi-transparent background.
3. **The Specular Highlight:** A 1px top border simulates light hitting the top edge of the glass.
4. **The Depth Shadow:** A subtle `box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3)` provides grounding.
5. **Interactive Depth:** Components must visually "sink" into the page when pressed by reducing the bottom-offset and increasing the Y-translation.

## Shapes

The system utilizes **Rounded** (Level 2) geometry. Main containers and cards use `0.75rem` (12px) corner radii. This creates a soft, approachable feel that balances the sharp typography and technical monospaced labels. Interactive floating elements (like the FAB) use "Full" roundedness (pill-shaped) to distinguish them as primary actions.

## Components

### Cards (Task Items)

Cards consist of two layers. The inner layer is the "glass" surface containing text. The outer layer is the "extrusion." For active tasks, use `font-body-lg` in `primary`. For completed tasks, reduce opacity to 60%, remove the 3D extrusion, and change the background to `completed-fill`.

### Floating Action Button (FAB)

The FAB is a circular glass element. It should be 64x64px with a 32px icon. It follows the same 3D tactile rules as cards, including the 6px bottom extrusion and the 1px specular top edge.

### Status Indicators

Metadata (like time or category) should use `label-md` (JetBrains Mono) and be wrapped in a container with 60% opacity to maintain hierarchy without cluttering the glass surface.

### Inputs

Input fields should mimic the "sunken" state of a completed task card (inset shadows, darker background) to indicate they are "hollow" areas ready to be filled, contrasting with the "raised" interactive buttons.
