const OrderHandler = {
    initAjax: function (formClass) {
        document.querySelectorAll(`.${formClass}`).forEach(form => {
            form.addEventListener('submit', function (e) {
                e.preventDefault();
                const btn = this.querySelector('button');
                const original = btn.innerHTML;
                btn.disabled = true; btn.innerHTML = "⏳...";

                fetch(this.action, {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(this)),
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                }).then(res => {
                    if (res.ok) {
                        btn.classList.add('btn-success'); btn.innerHTML = "✅ Xong";
                        setTimeout(() => {
                            btn.disabled = false; btn.innerHTML = original;
                            btn.classList.remove('btn-success');
                        }, 1000);
                    }
                });
            });
        });
    }
};