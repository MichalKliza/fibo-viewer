<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix = "weasel" uri = "tags/propertyRender.tld"%>

<!DOCTYPE HTML>
<html>

  <head>
    <jsp:directive.include file="page/elements/head.jsp" />
  </head>
  <body>
    <jsp:directive.include file="page/elements/header.jsp" />

    <button onclick="topFunction()" id="goToTopBtn" title="Go to top">Top</button>

    <c:set var = "clazz" value = "${details}"/>

    <div class="container-fluid">
      <div class="row px-3 py-3">
        <div class="col-md-3 px-2">
          <div class="card">
            <div class="card-body">
              <jsp:directive.include file="page/elements/moduleTree.jsp" />
            </div>
          </div>
        </div>

        <div class="col-md-9 px-2">

          <div class="card">
            <div class="card-body">
              <c:choose>
                <c:when test="${details_display}">
                  <c:choose>
                    <c:when test="${grouped_details}">
                      <jsp:directive.include file="page/elements/viewGrouped.jsp" />
                    </c:when>
                    <c:otherwise>
                      <jsp:directive.include file="page/elements/view.jsp" />
                    </c:otherwise>
                  </c:choose>
                </c:when>
                <c:otherwise>
                  Operation not supported...
                </c:otherwise>
              </c:choose>
            </div>

            <c:if test="${not empty clazz.graph}">
              <h5> <b class="mr-1 ml-4">Data model for "<i>${clazz.label}</i>"</b></h5> <br />
              <b class="mr-1 ml-4">Connections: </b> <br />
              <div class="ml-4">
                <label>
                  <input type="checkbox" name="edgesFilter" value="internal" checked="true">
                  class specyfic
                </label>
                <label>
                  <input type="checkbox" name="edgesFilter" value="external" checked="true">
                  inherited
                </label>
              </div>
              <div class="ml-4">
                <label>
                  <input type="checkbox" name="edgesFilter" value="optional" checked="true">
                  optional
                </label>
                <label>
                  <input type="checkbox" name="edgesFilter" value="non_optional" checked="true">
                  required
                </label>
              </div>
            </c:if>

            <div id="ontograph"></div>

            <script type="text/javascript">
              ${clazz.graph.toJsVars()}
              // create a network
              var container = document.getElementById('ontograph');
              const edgeFilters = document.getElementsByName('edgesFilter');

              const edgesFilterValues = {
                optional: true,
                non_optional: true,
                internal: true,
                external: true
              };
              const edgesFilter = (edge) => {
                return edgesFilterValues[edge.optional] && edgesFilterValues[edge.type];
              };
              edgeFilters.forEach(filter => function (e) {
                  filter.checked = "checked";
                });

              edgeFilters.forEach(filter => filter.addEventListener('change', (e) => {
                  const {value, checked} = e.target;
                  edgesFilterValues[value] = checked;
                  edgesView.refresh();
                }));
              const edgesView = new vis.DataView(edges, {filter: edgesFilter});
              var data = {
                nodes: nodes,
                edges: edgesView
              };
              var options = {
                "edges": {
                  "smooth": {
                    "type": "cubicBezier",
                    "forceDirection": "none",
                    "roundness": 0.15
                  }
                },
                "physics": {
                  "forceAtlas2Based": {
                    "gravitationalConstant": -95,
                    "centralGravity": 0.005,
                    "springLength": 200,
                    "springConstant": 0.415
                  },
                  "minVelocity": 0.75,
                  "solver": "forceAtlas2Based"
                }
              };
              var network = new vis.Network(container, data, options);
              var startHeight = 0;
              if (nodes.length !== 0) {
                startHeight = 500;
              }
              var height = startHeight + 20 * nodes.length;
              var container = document.getElementById('ontograph');

              container.style.height = height + 'px';
              network.redraw();

              network.on("doubleClick", function (params) {
                params.event = "[original event]";
                console.log('<h2>oncontext (right click) event:</h2>' + JSON.stringify(params, null, 4));
                var selectedNodes = params.nodes;
                var selectedEdges = params.edges;
                console.log(selectedNodes);
                console.log(selectedEdges);

                if (selectedNodes[0] !== undefined) {
                  var sNode = selectedNodes[0];
                  console.log(sNode);
                  nodes.forEach(function (entry) {
                    if (entry.id === sNode) {
                      window.location.href = "/search?query=" + entry.iri;
                      //localStorage.setItem("selectElementIri", );
                    }
                  });
                } else if (selectedEdges[0] !== undefined) {
                  var sEgde = selectedEdges[0];
                  console.log(sEgde);
                  edgesView.forEach(function (entry) {
                    if (entry.id === sEgde) {
                      window.location.href = "/search?query=" + entry.iri;
                    }
                  });
                }
                //show menu on right click on graph
                /*event.preventDefault();
                 $(".custom-menu").finish().toggle(100).
                 css({
                 top: event.pageY - 20 + "px",
                 left: event.pageX - 20 + "px"
                 });*/
              });
            </script>
          </div>

        </div>

      </div>
    </div>
    <!--
        <ul class='custom-menu'>
          <li data-action = "goto">Show info</li>
        </ul>
        <script type="text/javascript">
    
          $(".custom-menu").bind("mouseleave", function (e) {
            console.log("mouse leave");
            $(".custom-menu").hide(100);
          });
          $(".custom-menu li").click(function () {
    
            switch ($(this).attr("data-action")) {
    
              case "goto":
                $iri = localStorage.getItem("selectElementIri");
                window.location.href = "/search?query=" + $iri;
                break;
            }
            $(".custom-menu").hide(100);
          });
        </script>
    -->
    <jsp:directive.include file="page/elements/footer.jsp" />
  </body>

</html>
