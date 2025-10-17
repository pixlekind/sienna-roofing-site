const btn=document.getElementById("modeToggle");
if(btn){btn.addEventListener("click",()=>{document.body.classList.toggle("light");btn.textContent=document.body.classList.contains("light")?"🌞":"🌙";});}
