const CommonUtils = {    
    handleInitialRedirect: function(hiddenInputId) {
        const isLoggedIn = document.getElementById(hiddenInputId).value === 'true';
        
        setTimeout(() => {
            if (isLoggedIn) {
                window.location.href = 'rooms';
            } else {
                window.location.href = 'login';
            }
        }, 500);
    }
};