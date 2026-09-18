import { $$, $ } from '../utils/dom';

export function setupBanReasonsCheckbox() {
  const selectButtonTemplate = (select: HTMLElement | null, checked: boolean) => {
    select?.addEventListener('click', () => {
      $$<HTMLInputElement>('input[type="checkbox"].js-permitted-action-checkbox').forEach(
        cb => (cb.checked = checked)
      );
    });
  };

  selectButtonTemplate($('.js-select-all-global'), true);
  selectButtonTemplate($('.js-deselect-all-global'), false);

  const selectCategoryButtonTemplate = (selects: HTMLElement[], checked: boolean) => {
    if (!selects) return;
    for (const select of selects) {
      select.addEventListener('click', (e) => {
        e.stopPropagation();
        const section = select.closest('.category-section');
        if (section) {
          $$<HTMLInputElement>('.js-permitted-action-checkbox', section).forEach(
            cb => (cb.checked = checked)
          );
        }
      });
    }
  };

  selectCategoryButtonTemplate($$('.js-select-all-category'), true);
  selectCategoryButtonTemplate($$('.js-deselect-all-category'), false);
}
