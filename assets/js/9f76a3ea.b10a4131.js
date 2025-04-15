"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[267],{9788:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>a,contentTitle:()=>c,default:()=>l,frontMatter:()=>o,metadata:()=>s,toc:()=>u});const s=JSON.parse('{"id":"Introduction/best_practices","title":"Best Practices","description":"Recommended practices for using Axis","source":"@site/docs/Introduction/best_practices.md","sourceDirName":"Introduction","slug":"/Introduction/best_practices","permalink":"/Axis/docs/Introduction/best_practices","draft":false,"unlisted":false,"editUrl":"https://github.com/NeonD00m/axis/edit/main/docs/Introduction/best_practices.md","tags":[],"version":"current","sidebarPosition":2,"frontMatter":{"title":"Best Practices","description":"Recommended practices for using Axis","sidebar_position":2},"sidebar":"defaultSidebar","previous":{"title":"Getting Started","permalink":"/Axis/docs/Introduction/getting_started"},"next":{"title":"Example Game","permalink":"/Axis/docs/Introduction/example_game"}}');var i=n(4848),r=n(8453);const o={title:"Best Practices",description:"Recommended practices for using Axis",sidebar_position:2},c="Best Practices",a={},u=[];function d(e){const t={code:"code",h1:"h1",header:"header",p:"p",pre:"pre",...(0,r.R)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(t.header,{children:(0,i.jsx)(t.h1,{id:"best-practices",children:"Best Practices"})}),"\n",(0,i.jsx)(t.p,{children:"You have two main options while using Axis, you can either collect all your input axes in a single module for other systems to require, or you can define them in the systems that need them (may create redundancy)."}),"\n",(0,i.jsx)(t.pre,{children:(0,i.jsx)(t.code,{className:"language-lua",children:"local inputDelta = Axis.input {\r\n    Enum.UserInputType.MouseMovement,\r\n    [Enum.KeyCode.Thumbstick1] = 20,\r\n}\r\nlocal function camera()\r\n...\r\nend\n"})}),"\n",(0,i.jsx)(t.p,{children:"OR"}),"\n",(0,i.jsx)(t.pre,{children:(0,i.jsx)(t.code,{className:"language-lua",children:"local inputMap = {\r\n    inputDelta = Axis.input {\r\n        Enum.UserInputType.MouseMovement,\r\n        [Enum.KeyCode.Thumbstick1] = 20,\r\n    },\r\n    attack = Axis.input {\r\n        Enum.KeyCode.E,\r\n        Enum.KeyCode.ButtonA,\r\n    },\r\n    block = Axis.input {\r\n        Enum.KeyCode.F,\r\n    },\r\n}\r\nreturn inputMap\n"})}),"\n",(0,i.jsx)(t.p,{children:"Of course you can do something in between but at killer.gg we have found that containing all the input axes in a single module is the best option, since it allows us to easily access all of them in other systems (see mobileInput.luau and camera.luau in the example game)."}),"\n",(0,i.jsx)("br",{}),"\n",(0,i.jsx)("br",{}),"\n",(0,i.jsx)(t.p,{children:"More stuff soon probably"})]})}function l(e={}){const{wrapper:t}={...(0,r.R)(),...e.components};return t?(0,i.jsx)(t,{...e,children:(0,i.jsx)(d,{...e})}):d(e)}},8453:(e,t,n)=>{n.d(t,{R:()=>o,x:()=>c});var s=n(6540);const i={},r=s.createContext(i);function o(e){const t=s.useContext(r);return s.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function c(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:o(e.components),s.createElement(r.Provider,{value:t},e.children)}}}]);