From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] x86/mm: only allow memmap=XX!YY over existing RAM
Date: Sun, 19 Jun 2016 09:40:23 -0700
Message-ID: <CAPcyv4hiOwx5LM+80Hz7jWnidMrKVjY9V5B3zS7y_g7C1KLoYQ@mail.gmail.com>
References: <1466340570-2471502-1-git-send-email-yigal@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466340570-2471502-1-git-send-email-yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, jmoyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Jun 19, 2016 at 5:49 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org> wrote:
> Before this patch, passing a range that is beyond the physical memory
> range will succeed, the user will see a /dev/pmem0 and will be able to
> access it. Reads will always return 0 and writes will be silently
> ignored.
>
> I've gotten more than one bug report about mkfs.{xfs,ext4} or nvml
> failing that were eventually tracked down to be wrong values passed to
> memmap.
>
> This patch prevents the above issue by instead of adding a new memory
> range, only update a RAM memory range with the PRAM type. This way,
> passing the wrong memmap will either not give you a pmem at all or give
> you a smaller one that actually has RAM behind it.
>
> And if someone still needs to fake a pmem that doesn't have RAM behind
> it, they can simply do memmap=XX@YY,XX!YY.

Thanks!  I've debugged a report like this as well.
