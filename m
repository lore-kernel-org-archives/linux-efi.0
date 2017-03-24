From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 09:42:40 +0000
Message-ID: <CAKv+Gu9cyMccPSjzr9XGT6Gkhq57is+i_VajsZMTbd9eOAMkwQ@mail.gmail.com>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com> <20170324083451.GC30442@x1>
 <20170324084609.GA6807@dhcp-128-65.nay.redhat.com> <20170324092433.GA3237@gmail.com>
 <CAKv+Gu_V_VAWuDtKyOY9RS+cdhi+c5z2a7n2kcXVybvvdmPYBw@mail.gmail.com> <20170324094034.2afxgg43wlezdka5@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170324094034.2afxgg43wlezdka5@pd.tnic>
Sender: stable-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 09:40, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Mar 24, 2017 at 09:37:36AM +0000, Ard Biesheuvel wrote:
>> No. It is the firmware's EFI code, and the virtual translation applied
>> by the OS is made known to the firmware by means of a call into the
>> runtime service SetVirtualAddressMap().
>
> We can still randomize within those 64G before calling
> SetVirtualAddressMap(). The question is, do we want to or need to, even?
>

That is a different matter. If the regions are only mapped while
runtime services invocations are in progress (as we do on ARM), I am
not sure if it matters that much, given how rarely that occurs in
normal use.
