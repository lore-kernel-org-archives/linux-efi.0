From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v2] efi: take size of partition entry from GPT header
Date: Mon, 8 Oct 2018 13:15:25 +0200
Message-ID: <20181008111525.hm6jcnlsf7xrjre3@ws.net.home>
References: <20180911161527.GA30689@vnote>
 <20180912083844.iegei2kobcz4b7ag@ws.net.home>
 <6d349d22d37041c1a2942d8ed4c76b69@AcuMS.aculab.com>
 <CAJC2YLaug4=7otnRC7x+UdDp=5ErgJFHFL_7mjRO7sdM2CrUfQ@mail.gmail.com>
 <2db38b2d1af34ab9b653c665d08872f1@AcuMS.aculab.com>
 <20180914110703.ishvqwcpcf5ozihy@ws.net.home>
 <CAJC2YLYqb6WB43P5pJe=D7GXgUY16PS=QLVJbD8=qEH=aB9qvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJC2YLYqb6WB43P5pJe=D7GXgUY16PS=QLVJbD8=qEH=aB9qvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>
Cc: David.Laight@aculab.com, Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 06, 2018 at 09:41:27PM +0300, Eugene Korenevsky wrote:
> > is_gpt_valid() already contains
> >         pt_size = (u64)le32_to_cpu((*gpt)->num_partition_entries) *
> >                 le32_to_cpu((*gpt)->sizeof_partition_entry);
> >         if (pt_size > KMALLOC_MAX_SIZE)
> >                 pr_debug("GUID Partition Table is too large: %llu > %lu bytes\n",
> >                 (unsigned long long)pt_size, KMALLOC_MAX_SIZE);
> >                 goto fail;
> >         }
> > I guess it good enough for sanity check.
> >
> > If you want to be really paranoid than you can also check that array
> > is possible to store to the expected area on the disk:
> >
> >     pt_size <= (gpt->first_usable_lba - gpt->partition_entry_lba)
> >
> 
> Well, we should apply several checks for different cases:
> - primary GPT: table entries should not override gpt->first_usable_lba

 and gpt->last_usable_lba

> - alternate GPT, table entries BEFORE agpt (agpt->partition_entry_lba
> < agpt_lba): table entries should not override agpt_lba AND
> agpt->partition_entry_lba MUST BE more than agpt->last_usable_lba
> - alternate GPT, table entries AFTER agpt (agpt->partition_entry_lba >
> agpt_lba): table entries should not override the end of the disk
> 
> Is this correct?

Yes, the table defines range for all partitions (last and first usable
LBA). All partition table stuff (label and partitions array) has to be
outside this area and partitions have to point to this area.

                   
 | label | entries |    partitioned area   | backup-entries | backup-label |
 
                   ^                       ^
             first_usable_lba        last_usable_lba


and it's possible and valid if there is gap between entries array and 
first usable LBA (you can use this unused place to hide same data :-) 
And vice-versa for backup entries and last usable LBA. 

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
