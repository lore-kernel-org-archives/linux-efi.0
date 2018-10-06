From: Eugene Korenevsky <ekorenevsky@gmail.com>
Subject: Re: [PATCH v2] efi: take size of partition entry from GPT header
Date: Sat, 6 Oct 2018 21:41:27 +0300
Message-ID: <CAJC2YLYqb6WB43P5pJe=D7GXgUY16PS=QLVJbD8=qEH=aB9qvg@mail.gmail.com>
References: <20180911161527.GA30689@vnote> <20180912083844.iegei2kobcz4b7ag@ws.net.home>
 <6d349d22d37041c1a2942d8ed4c76b69@AcuMS.aculab.com> <CAJC2YLaug4=7otnRC7x+UdDp=5ErgJFHFL_7mjRO7sdM2CrUfQ@mail.gmail.com>
 <2db38b2d1af34ab9b653c665d08872f1@AcuMS.aculab.com> <20180914110703.ishvqwcpcf5ozihy@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914110703.ishvqwcpcf5ozihy@ws.net.home>
Sender: linux-kernel-owner@vger.kernel.org
To: kzak@redhat.com
Cc: David.Laight@aculab.com, Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> is_gpt_valid() already contains
>         pt_size = (u64)le32_to_cpu((*gpt)->num_partition_entries) *
>                 le32_to_cpu((*gpt)->sizeof_partition_entry);
>         if (pt_size > KMALLOC_MAX_SIZE)
>                 pr_debug("GUID Partition Table is too large: %llu > %lu bytes\n",
>                 (unsigned long long)pt_size, KMALLOC_MAX_SIZE);
>                 goto fail;
>         }
> I guess it good enough for sanity check.
>
> If you want to be really paranoid than you can also check that array
> is possible to store to the expected area on the disk:
>
>     pt_size <= (gpt->first_usable_lba - gpt->partition_entry_lba)
>

Well, we should apply several checks for different cases:
- primary GPT: table entries should not override gpt->first_usable_lba
- alternate GPT, table entries BEFORE agpt (agpt->partition_entry_lba
< agpt_lba): table entries should not override agpt_lba AND
agpt->partition_entry_lba MUST BE more than agpt->last_usable_lba
- alternate GPT, table entries AFTER agpt (agpt->partition_entry_lba >
agpt_lba): table entries should not override the end of the disk

Is this correct?

--
Eugene
