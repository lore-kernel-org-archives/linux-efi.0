From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v8 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Fri, 12 Oct 2018 18:03:38 +0800
Message-ID: <20181012100338.GB1898@localhost.localdomain>
References: <20181010084119.17539-1-fanc.fnst@cn.fujitsu.com>
 <20181010084119.17539-2-fanc.fnst@cn.fujitsu.com>
 <20181011105708.GB25435@zn.tnic>
 <20181012093638.GA1898@localhost.localdomain>
 <20181012094655.GB12328@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181012094655.GB12328@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 12, 2018 at 11:46:55AM +0200, Borislav Petkov wrote:
>On Fri, Oct 12, 2018 at 05:36:38PM +0800, Chao Fan wrote:
>> Prefer to compile out entire functions, rather than portions of functions or
>> portions of expressions.  Rather than putting an ifdef in an expression, factor
>> out part or all of the expression into a separate helper function and apply the
>> conditional to that function.
>> 
>> So I am puzzled. If my understanding is wrong, please let me know.
>
>If you do it the way I suggested, you simply have one ifdeffery branch
>less. And ifdeffery is ugly. So less clutter. Also, this way you do
>compile out entire functions too.
>
>HTH.

Got it, thanks for your rapid reply.

Thanks,
Chao Fan

>
>-- 
>Regards/Gruss,
>    Boris.
>
>Good mailing practices for 400: avoid top-posting and trim the reply.
>
>
