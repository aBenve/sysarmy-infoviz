---
toc: false
sql:
  db: ./data/2024-01.csv
---

<div class="hero">
  <h1>Sysarmy</h1>
  <span>This is a clone of the sysarmy salary survey 2024 with Observable Framework</span>
  
  <h2>About the Project</h2>
  <div class="">
  <p>This project was carried out by students of the Information Visualization course at ITBA.</p>
  <p>It is based on the <a href="https://sueldos.openqube.io/encuesta-sueldos-2024.01/" target="_blank">semi-annual survey</a> conducted by the Sysarmy community, detailing the current state and providing a historical analysis of jobs in the systems field in Argentina.</p>
  <p>Data published by Sysarmy was collected for each semester of the last 10 years, and two datasets were generated based on this: one with information from the last semester (first semester of 2024) and the other with all the historical content. This approach was taken due to the enormous variation in the collected information (questions and options presented to respondents), so the historical dataset is more limited as it is restricted to questions that are common to all semesters.</p>
  <p>Based on this data, the charts presented in the latest Sysarmy survey were implemented using the <a href="https://observablehq.com/framework/getting-started" target="_blank">Observable Framework</a>.</p>
  </div>

  <h4><u>Participants:</u></h5>
  <ul>
  <li>Agustin Benvenuto</li>
  <li>Alan Sartorio</li>
  <li>Agustin Galarza</li>
  </ul>
</div>

<!-- This styles seem to be global -->

<style>

.hero {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: var(--sans-serif);
  margin: 4rem 0 8rem;
  text-wrap: balance;
  text-align: center;
}

.hero span {
  margin-bottom: 0.5rem;
}

.hero p {
  max-width: 80ch;
  margin-left: auto;
  margin-right: auto;
  text-wrap: wrap;
}

.hero h1 {
  margin: 1rem 0;
  padding: 1rem 0;
  max-width: none;
  font-size: 14vw;
  font-weight: 900;
  line-height: 1;
  background: linear-gradient(30deg, var(--theme-foreground-focus), currentColor);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero h2 {
  margin: 0;
  margin-top: 1rem;
  max-width: 34em;
  font-size: 20px;
  font-style: initial;
  font-weight: 500;
  line-height: 1.5;
  color: var(--theme-foreground-muted);
}

.hero h4 {
  margin-top: 1rem;
}

.hero ul {
  text-align: start;
  margin-top: 0.5rem;
}

@media (min-width: 640px) {
  .hero h1 {
    font-size: 90px;
  }
}

</style>
