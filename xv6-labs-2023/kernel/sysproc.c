#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

#define MAX_PAGES 32

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  uint64 base;    // Địa chỉ cơ sở của vùng nhớ cần kiểm tra
  int num;        // Số lượng trang
  uint64 bitmap_u;  // Địa chỉ để lưu bitmap kết quả

  // Lấy tham số từ tiến trình người dùng
  argaddr(0, &base);
  argint(1, &num);
  argaddr(2, &bitmap_u);

  if (num < 0) // Kiểm tra số lượng trang hợp lệ
    return -1;

  if (num > MAX_PAGES)
    num = MAX_PAGES; // Giới hạn số trang có thể truy cập

  struct proc *p = myproc();
  uint64 bitmap = 0;

  for (int i = 0; i < num; i++) {
    uint64 va = base + i * PGSIZE; // Tính địa chỉ từng trang
    pte_t *pte = walk(p->pagetable, va, 0); // Tìm PTE của trang

    if (!pte || (*pte & PTE_V) == 0) // Kiểm tra PTE hợp lệ và được ánh xạ
      continue;

    if (*pte & PTE_A) // Kiểm tra bit PTE_A (trang đã truy cập)
    { 
      bitmap |= (1L << i); // Đặt bit tương ứng trong bitmap
      *pte &= ~PTE_A;      // Xóa bit PTE_A
    }
  }

  // Sao chép kết quả bitmap từ kernel sang user space
  if (copyout(p->pagetable, bitmap_u, (char *)&bitmap, sizeof(bitmap)) < 0)
    return -1;

  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
