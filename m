From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH v2 0/7] efi: Enhance capsule loader to support signed
 Quark images
Date: Tue, 28 Mar 2017 01:48:38 +0100
Message-ID: <8c09afc1-9b1d-d1e4-e634-f2b405340840@nexus-software.ie>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
 <d3c887cb-fede-bfc6-8b1d-a6dca262b5bc@nexus-software.ie>
 <7cff4583-d417-7107-80a3-34eb63d43be1@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7cff4583-d417-7107-80a3-34eb63d43be1-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 27/03/17 12:01, Jan Kiszka wrote:
> The reset method is auto-adjusted by the kernel when an update is
> pending. So firmware update is now seriously simple. But I can write a 2
> or 3-lines readme if it's preferred.

Using myself as a benchmark I'd say, never assume anything is idiot 
proof to a sufficiently talented idiot, better to document it to be sure 
and give you're spinning a new patch for some comments from Andy I'd say 
it's a worthwhile addition to the set.

---
bod
