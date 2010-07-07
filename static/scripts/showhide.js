function toggle(id)
{
    obj = document.getElementById(id) ;

    if (obj.style.display != 'block') obj.style.display = 'block';
    else obj.style.display = 'none' ;
}