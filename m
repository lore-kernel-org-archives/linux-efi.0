From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 08 Feb 2013 11:42:50 -0800
Message-ID: <5115553A.5000708@zytor.com>
References: <20130208191213.GA25081@www.outflux.net> <00780235-deac-4f80-b936-867834e05661@email.android.com> <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <matthew.garrett@nebula.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 02/08/2013 11:18 AM, Kees Cook wrote:
> No. CAP_RAWIO is for reading. Writing needs a much stronger check.
>
> -Kees

If so, I suspect we need to do this for *all* raw I/O... but I keep 
wondering how much more sensitive writing really is than reading.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
