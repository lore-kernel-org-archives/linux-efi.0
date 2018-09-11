From: Eugene Korenevsky <ekorenevsky@gmail.com>
Subject: Re: [PATCH v2] efi: take size of partition entry from GPT header
Date: Tue, 11 Sep 2018 19:42:11 +0300
Message-ID: <CAJC2YLatWGvWv3abt7jQSk06rOQKTtkH4RxyPda6-usztFzwBg@mail.gmail.com>
References: <20180911161527.GA30689@vnote> <20180911162741.GC3902@linux-r8p5>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911162741.GC3902@linux-r8p5>
Sender: linux-kernel-owner@vger.kernel.org
To: dave@stgolabs.net
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

> >The GPT with entries sized more than sizeof(gpt_entry) is not illegal.
> >OVMF firmware from EDK2 perfectly works with it, see edk2-tianocore source
> >code.

> But _why_ is this needed? Does this firmware need larger sized entries (ie: does
> not work without it)?

A disk with correct large-sized GPT entries can be created. UEFI
firmwares will work with it, Linux kernel will not. Is it necessary to
perform such synthetic test or this issue does not matter anyway?

--
Eugene
