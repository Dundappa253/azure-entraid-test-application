<div id="loader-content-<%= request.getParameter("loader-id") %>" style="display:none">
     <div class="alert alert-info">
          <p><%= request.getParameter("loader-message") %> ...</p>
          <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
      </div>
     </div>
</div>