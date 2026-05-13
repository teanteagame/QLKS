const TableManager = {
    // Tìm kiếm nhanh
    initSearch: function (inputId, tableId) {
        const input = document.getElementById(inputId);
        const table = document.getElementById(tableId);
        if (!input || !table) return;
        input.addEventListener('keyup', function () {
            const filter = this.value.toLowerCase();
            const rows = table.querySelectorAll('tbody tr:not(#noDataRow)');
            rows.forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(filter) ? '' : 'none';
            });
        });
    },
    // Sắp xếp cột
    sortTable: function (tableId, colIndex, type = 'text') {
        const table = document.getElementById(tableId);
        let rows = Array.from(table.rows).slice(1);
        let isAsc = table.querySelectorAll('th')[colIndex].classList.toggle('asc');
        
        rows.sort((a, b) => {
            let x = a.cells[colIndex].innerText.trim();
            let y = b.cells[colIndex].innerText.trim();
            if (type === 'number') return isAsc ? x - y : y - x;
            return isAsc ? x.localeCompare(y) : y.localeCompare(x);
        });
        rows.forEach(row => table.appendChild(row));
    }
};