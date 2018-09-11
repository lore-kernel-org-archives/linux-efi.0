From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v2] efi: take size of partition entry from GPT header
Date: Tue, 11 Sep 2018 09:27:41 -0700
Message-ID: <20180911162741.GC3902@linux-r8p5>
References: <20180911161527.GA30689@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180911161527.GA30689@vnote>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Sep 2018, Eugene Korenevsky wrote:

>Use gpt_header.sizeof_partition_entry instead of sizeof(gpt_entry)
>for GPT entry size.
>According to UEFI 2.7 spec 5.3.1 "GPT overview":, the size of a GUID Partition
>Entry element is defined in the Size Of Partition Entry field of GPT header.
>The GPT with entries sized more than sizeof(gpt_entry) is not illegal.
>OVMF firmware from EDK2 perfectly works with it, see edk2-tianocore source
>code.

But _why_ is this needed? Does this firmware need larger sized entries (ie: does
not work without it)?

Thanks,
Davidlohr
