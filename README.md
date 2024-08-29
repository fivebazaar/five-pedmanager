# 🚶‍♂️ Five-PedManager

A versatile FiveM script that allows you to manage pedestrians (peds) in your server with ease. With this script, you can create, customize, and animate peds, as well as manage their behavior dynamically based on in-game conditions like weather.

## ✨ Features

- 🎭 **Create and Customize Peds**: Easily create peds with unique names, set their models, and customize their appearance.
- 🛑 **Freeze/Unfreeze Peds**: Control the movement of peds by freezing or unfreezing them at will.
- 🎬 **Animations**: Apply various animations to your peds, making them interact naturally with the environment.
- ☂️ **Dynamic Behavior**: Automatically give peds umbrellas during rain, adding a realistic touch to your server.
- 🔄 **Cleanup**: Automatically clean up peds when the resource stops to ensure your server stays optimized.

## 🎥 Video Demo

Check out our [**video demo**](https://www.youtube.com) to see the Five-PedManager in action! Watch how easy it is to manage peds in your server.

## 📖 Documentation

For detailed documentation on how to use the Five-PedManager, visit our [**GitBook page**](https://fivebazaar.gitbook.io/overview/five-pedmanager). The documentation includes installation instructions, function descriptions, and usage examples.

## 💬 Join Our Community

Have questions, suggestions, or just want to hang out with other developers? Join our [**Discord server**](https://discord.gg/Dc6EVAUxu6) where we discuss all things related to FiveM scripting and more!

## 📥 Installation

1. **Download the Resource**: Clone or download this repository.
2. **Add to Your Server**: Place the `five-pedmanager` folder into your FiveM server's `resources` directory.
3. **Update Your `server.cfg`**: Add `ensure five-pedmanager` to your `server.cfg` to ensure the resource starts when your server does.

## 🛠️ Usage

Use the exports provided by this script to manage peds in your server:

```lua
-- Create a new ped
exports['five-pedmanager']:createPed('farmer_1', 'a_m_m_farmer_01', vector4(122.2, 97.2, 81.43, 180), true, true, 'amb@world_human_hang_out_street@male_a@idle_a', 'idle_a')

-- Freeze or unfreeze a ped
exports['five-pedmanager']:pedFreeze('farmer_1', false)

-- Customize a ped's outfit
exports['five-pedmanager']:peddressup('farmer_1', 3, 5, 0)

-- Make a ped perform an animation
exports['five-pedmanager']:pedemote('farmer_1', 'amb@world_human_drinking@coffee@male@base', 'base')

-- Get the current animation of a ped
local pedanim = exports['five-pedmanager']:getpedemote('farmer_1', 'animName')
