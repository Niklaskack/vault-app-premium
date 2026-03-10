import os
from PIL import Image
import math

files = {
    'onboarding_shield.png': r'C:\Users\stone\.gemini\antigravity\brain\39172e5d-3019-496a-b965-abc09f3f2f4b\onboarding_shield_1773011089199.png',
    'onboarding_sync.png': r'C:\Users\stone\.gemini\antigravity\brain\39172e5d-3019-496a-b965-abc09f3f2f4b\onboarding_sync_1773011103905.png',
    'onboarding_intel.png': r'C:\Users\stone\.gemini\antigravity\brain\39172e5d-3019-496a-b965-abc09f3f2f4b\onboarding_intel_1773011115465.png',
    'onboarding_control.png': r'C:\Users\stone\.gemini\antigravity\brain\39172e5d-3019-496a-b965-abc09f3f2f4b\onboarding_control_1773011128968.png',
}

os.makedirs('assets/images', exist_ok=True)

for name, path in files.items():
    img = Image.open(path).convert('RGB')
    width, height = img.size
    
    img_out = Image.new('RGBA', (width, height), (0,0,0,0))
    pixels_in = img.load()
    pixels_out = img_out.load()
    
    cx, cy = width / 2.0, height / 2.0
    radius_outer = min(width, height) / 2.0 - 5
    
    for y in range(height):
        for x in range(width):
            r, g, b = pixels_in[x, y]
            lum = max(r, g, b)
            
            if lum == 0:
                continue
            
            alpha = lum
            nr = int((r * 255.0) / lum)
            ng = int((g * 255.0) / lum)
            nb = int((b * 255.0) / lum)
            
            # apply circle mask
            dist = math.hypot(x - cx, y - cy)
            if dist > radius_outer:
                continue
                
            aa = 1.0
            if dist > radius_outer - 2:
                aa = (radius_outer - dist) / 2.0
            if aa < 0: aa = 0
            if aa > 1: aa = 1
                
            pixels_out[x, y] = (nr, ng, nb, int(alpha * aa))
            
    # Save the processed image!
    img_out.save(f'assets/images/{name}')
    print(f'Processed {name}')
