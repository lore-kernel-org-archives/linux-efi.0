From: Eugene Korenevsky <ekorenevsky@gmail.com>
Subject: Re: [PATCH v3] efi: take size of partition entry from GPT header
Date: Thu, 13 Sep 2018 22:44:56 +0300
Message-ID: <CAJC2YLb+YM11jzWLVTea6gEa=Ou2rdJC1rY9TbK+yOpAfyWFyg@mail.gmail.com>
References: <20180912183519.GA31506@vnote> <20180912185517.GE3902@linux-r8p5> <c158b639852d48d382445d33da8c6a1e@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c158b639852d48d382445d33da8c6a1e@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David.Laight@aculab.com
Cc: Davidlohr Bueso <dave@stgolabs.net>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> > Please rearrange this like:
> >
> >        for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) &&
> >                             i < state->limit-1; i++)
>
> Better still cache le32_to_cpu(gpt->num_partition_entries) to a local
> so that it only has to be calculated once (even if it gets spilled
> to the stack).
> It can be bounded by state->limit-1 at the same time.

This is block I/O, slow path. No need for such micro optimizations here.
GCC is capable to do such optimizations automatically, and it does as
I can see from disassembly.
Anyway this would be a subject for another patch.

-- 
Eugene
