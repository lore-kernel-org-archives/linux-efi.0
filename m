From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Wed, 30 Jul 2014 13:43:14 -0700
Message-ID: <53D958E2.6070704@infradead.org>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <20140730144803.GB15082@console-pimps.org> <53D909C3.9050205@canonical.com> <53D9259F.5050307@redhat.com> <53D92700.3040803@infradead.org> <53D92996.1050906@zytor.com> <20140730195821.GE10213@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140730195821.GE10213@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Prarit Bhargava <prarit@redhat.com>, Matt Fleming <matt@console-pimps.org>, Colin Ian King <colin.king@canonical.com>, linux-kernel@vger.kernel.org, lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 07/30/14 12:58, Borislav Petkov wrote:
> On Wed, Jul 30, 2014 at 10:21:26AM -0700, H. Peter Anvin wrote:
>> Arguably the exactness is available in the range...
> 
> ... and the size too. FWIW, other region dumps don't even print size:
> 
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> ...
> 
> If we do that too for UEFI, we can certainly put an end to the
> bikeshedding... provided everyone is tired of it by now. :-P

Yes, please.  (I'm tired and I barely got started ;)

-- 
~Randy
