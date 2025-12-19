# FPGA True Random Number Generator (TRNG)

Acest proiect implementează un **generator de numere aleatoare (TRNG – True Random Number Generator)** pe FPGA, folosind o sursă de entropie bazată pe jitter, filtrare statistică și corecție Von Neumann.

Proiectul a fost realizat și simulat folosind **Vivado**.

---

## Arhitectura proiectului

Structura generală a sistemului este:

Entropy Model → Window Filter → Von Neumann Corrector → Generator număr (8 biți)

---

## Modulele proiectului

### `entropy_model`
- Simulează o sursă de entropie bazată pe jitter de fază
- Utilizează un LFSR și un acumulator de fază
- Produce bitul brut `rnd_raw`
- În simulare, comportamentul este determinist; pe FPGA, entropia este fizică

---

### `window_filter`
- Reduce bias-ul statistic (prea mulți biți de 0 sau 1)
- Analizează o fereastră de biți
- Produce bitul filtrat `rnd_entropy`

---

### `von_neumann_corrector`
- Elimină corelațiile statistice dintre biți
- Analizează biții în perechi:
  - `01 → valid`
  - `10 → valid`
  - `00 / 11 → ignorate`
- Produce:
  - `vn_bit` – bit corectat
  - `vn_valid` – semnal de validare (1 ciclu de ceas)

---

### `trng_top`
- Conectează toate modulele
- Colectează 8 biți validați
- Generează un număr random pe 8 biți:
  - `final_number`
  - `number_ready` (semnal de disponibilitate)

---

## Simulare

Simularea a fost realizată în Vivado.
Numerele random pot fi observate:
- în waveform
- în consola de simulare

Exemple de valori generate (difera de la o rulare la alta):
<img width="1606" height="608" alt="Screenshot 2025-12-19 185258" src="https://github.com/user-attachments/assets/709d0cd8-62fd-414c-804f-ea92c05e6ee3" />


---

## Observații importante
- În simulare, secvența de biți este repetabilă din cauza seed-ului fix
- Pe placa FPGA, generatorul produce entropie fizică reală
- Semnalul `vn_valid` pulsează rar, ceea ce este normal
- Proiectul poate fi extins pentru a genera numere pe 16 sau 32 de biți

---

## Concluzie
Acest proiect demonstrează implementarea unui **TRNG funcțional**, capabil să genereze numere aleatoare validate statistic, pregătit pentru rulare pe FPGA.

---





