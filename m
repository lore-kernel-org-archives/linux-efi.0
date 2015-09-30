From: "Izumi, Taku" <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: RE: [PATCH 2/2] x86, efi: Add "efi_fake_mem" boot option
Date: Wed, 30 Sep 2015 04:51:12 +0000
Message-ID: <E86EADE93E2D054CBCD4E708C38D364A5427BD0A@G01JPEXMBYT01>
References: <1443608419-37801-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <201509300948.PGoujrqX%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201509300948.PGoujrqX%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: ja-JP
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "kbuild-all-JC7UmRfGjtg@public.gmane.org" <kbuild-all-JC7UmRfGjtg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "qinxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <qinxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Kamezawa, Hiroyuki" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

 I've missed git-format-patch after rebasing.
 I'll resend right one..

> -----Original Message-----
> From: kbuild test robot [mailto:lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, September 30, 2015 10:37 AM
> To: Izumi, Taku/泉 拓
> Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org; mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org; tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; qinxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org; Kamezawa, Hiroyuki/亀
> 澤 寛之; ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org; Izumi, Taku/泉 拓
> Subject: Re: [PATCH 2/2] x86, efi: Add "efi_fake_mem" boot option
> 
> Hi Taku,
> 
> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
> 
> config: i386-allmodconfig (attached as .config)
> reproduce:
>   git checkout afcc94d3f91a00ce97d735a563a8e5d595f45a03
>   # save the attached .config to linux build tree
>   make ARCH=i386
> 
> All error/warnings (new ones prefixed by >>):
> 
> >> drivers/firmware/efi/fake_mem.c:36:25: error: 'CONFIG_EFI_MAX_FAKEMEM' undeclared here (not in a function)
>     #define EFI_MAX_FAKEMEM CONFIG_EFI_MAX_FAKEMEM
>                             ^
> >> drivers/firmware/efi/fake_mem.c:42:34: note: in expansion of macro 'EFI_MAX_FAKEMEM'
>     static struct fake_mem fake_mems[EFI_MAX_FAKEMEM];
>                                      ^
>    drivers/firmware/efi/fake_mem.c: In function 'efi_fake_memmap':
> >> drivers/firmware/efi/fake_mem.c:186:20: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      memmap.phys_map = (void *)new_memmap_phy;
>                        ^
>    drivers/firmware/efi/fake_mem.c: At top level:
> >> drivers/firmware/efi/fake_mem.c:42:24: warning: 'fake_mems' defined but not used [-Wunused-variable]
>     static struct fake_mem fake_mems[EFI_MAX_FAKEMEM];
>                            ^
> 
> vim +/CONFIG_EFI_MAX_FAKEMEM +36 drivers/firmware/efi/fake_mem.c
> 
>     30	#include <linux/init.h>
>     31	#include <linux/memblock.h>
>     32	#include <linux/types.h>
>     33	#include <linux/sort.h>
>     34	#include <asm/efi.h>
>     35
>   > 36	#define EFI_MAX_FAKEMEM CONFIG_EFI_MAX_FAKEMEM
>     37
>     38	struct fake_mem {
>     39		struct range range;
>     40		u64 attribute;
>     41	};
>   > 42	static struct fake_mem fake_mems[EFI_MAX_FAKEMEM];
>     43	static int nr_fake_mem;
>     44
>     45	static int __init cmp_fake_mem(const void *x1, const void *x2)
>     46	{
>     47		const struct fake_mem *m1 = x1;
>     48		const struct fake_mem *m2 = x2;
>     49
>     50		if (m1->range.start < m2->range.start)
>     51			return -1;
>     52		if (m1->range.start > m2->range.start)
>     53			return 1;
>     54		return 0;
>     55	}
>     56
>     57	void __init efi_fake_memmap(void)
>     58	{
>     59		u64 start, end, m_start, m_end, m_attr;
>     60		int new_nr_map = memmap.nr_map;
>     61		efi_memory_desc_t *md;
>     62		u64 new_memmap_phy;
>     63		void *new_memmap;
>     64		void *old, *new;
>     65		int i;
>     66
>     67		if (!nr_fake_mem || !efi_enabled(EFI_MEMMAP))
>     68			return;
>     69
>     70		/* count up the number of EFI memory descriptor */
>     71		for (old = memmap.map; old < memmap.map_end; old += memmap.desc_size) {
>     72			md = old;
>     73			start = md->phys_addr;
>     74			end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
>     75
>     76			for (i = 0; i < nr_fake_mem; i++) {
>     77				/* modifying range */
>     78				m_start = fake_mems[i].range.start;
>     79				m_end = fake_mems[i].range.end;
>     80
>     81				if (m_start <= start) {
>     82					/* split into 2 parts */
>     83					if (start < m_end && m_end < end)
>     84						new_nr_map++;
>     85				}
>     86				if (start < m_start && m_start < end) {
>     87					/* split into 3 parts */
>     88					if (m_end < end)
>     89						new_nr_map += 2;
>     90					/* split into 2 parts */
>     91					if (end <= m_end)
>     92						new_nr_map++;
>     93				}
>     94			}
>     95		}
>     96
>     97		/* allocate memory for new EFI memmap */
>     98		new_memmap_phy = memblock_alloc(memmap.desc_size * new_nr_map,
>     99						PAGE_SIZE);
>    100		if (!new_memmap_phy)
>    101			return;
>    102
>    103		/* create new EFI memmap */
>    104		new_memmap = early_memremap(new_memmap_phy,
>    105					    memmap.desc_size * new_nr_map);
>    106		if (!new_memmap) {
>    107			memblock_free(new_memmap_phy, memmap.desc_size * new_nr_map);
>    108			return;
>    109		}
>    110
>    111		for (old = memmap.map, new = new_memmap;
>    112		     old < memmap.map_end;
>    113		     old += memmap.desc_size, new += memmap.desc_size) {
>    114
>    115			/* copy original EFI memory descriptor */
>    116			memcpy(new, old, memmap.desc_size);
>    117			md = new;
>    118			start = md->phys_addr;
>    119			end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
>    120
>    121			for (i = 0; i < nr_fake_mem; i++) {
>    122				/* modifying range */
>    123				m_start = fake_mems[i].range.start;
>    124				m_end = fake_mems[i].range.end;
>    125				m_attr = fake_mems[i].attribute;
>    126
>    127				if (m_start <= start && end <= m_end)
>    128					md->attribute |= m_attr;
>    129
>    130				if (m_start <= start &&
>    131				    (start < m_end && m_end < end)) {
>    132					/* first part */
>    133					md->attribute |= m_attr;
>    134					md->num_pages = (m_end - md->phys_addr + 1) >>
>    135						EFI_PAGE_SHIFT;
>    136					/* latter part */
>    137					new += memmap.desc_size;
>    138					memcpy(new, old, memmap.desc_size);
>    139					md = new;
>    140					md->phys_addr = m_end + 1;
>    141					md->num_pages = (end - md->phys_addr + 1) >>
>    142						EFI_PAGE_SHIFT;
>    143				}
>    144
>    145				if ((start < m_start && m_start < end) && m_end < end) {
>    146					/* first part */
>    147					md->num_pages = (m_start - md->phys_addr) >>
>    148						EFI_PAGE_SHIFT;
>    149					/* middle part */
>    150					new += memmap.desc_size;
>    151					memcpy(new, old, memmap.desc_size);
>    152					md = new;
>    153					md->attribute |= m_attr;
>    154					md->phys_addr = m_start;
>    155					md->num_pages = (m_end - m_start + 1) >>
>    156						EFI_PAGE_SHIFT;
>    157					/* last part */
>    158					new += memmap.desc_size;
>    159					memcpy(new, old, memmap.desc_size);
>    160					md = new;
>    161					md->phys_addr = m_end + 1;
>    162					md->num_pages = (end - m_end) >>
>    163						EFI_PAGE_SHIFT;
>    164				}
>    165
>    166				if ((start < m_start && m_start < end) &&
>    167				    (end <= m_end)) {
>    168					/* first part */
>    169					md->num_pages = (m_start - md->phys_addr) >>
>    170						EFI_PAGE_SHIFT;
>    171					/* latter part */
>    172					new += memmap.desc_size;
>    173					memcpy(new, old, memmap.desc_size);
>    174					md = new;
>    175					md->phys_addr = m_start;
>    176					md->num_pages = (end - md->phys_addr + 1) >>
>    177						EFI_PAGE_SHIFT;
>    178					md->attribute |= m_attr;
>    179				}
>    180			}
>    181		}
>    182
>    183		/* swap into new EFI memmap */
>    184		efi_unmap_memmap();
>    185		memmap.map = new_memmap;
>  > 186		memmap.phys_map = (void *)new_memmap_phy;
>    187		memmap.nr_map = new_nr_map;
>    188		memmap.map_end = memmap.map + memmap.nr_map * memmap.desc_size;
>    189		set_bit(EFI_MEMMAP, &efi.flags);
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
