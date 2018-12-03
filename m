From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] pstore: Convert buf_lock to semaphore
Date: Mon, 3 Dec 2018 12:18:29 +0100
Message-ID: <20181203111826.ri2csbxs33j34dvo@linutronix.de>
References: <20181130224736.GA38485@beast>
 <CAK8P3a0YGyKf_0wg_sNhN2z-zVvv1N1_Yc=+2AL=8FZT+CRLxQ@mail.gmail.com>
 <CAGXu5jKXEEHbxdG2VzYhUWEPEEJYdCLEY1oF+zm8wOUfdS0v+A@mail.gmail.com>
 <CAK8P3a3xUMnWrSsW6gNwc5y0z-wR23v8Q6TGH+yNpDJq65FeMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a3xUMnWrSsW6gNwc5y0z-wR23v8Q6TGH+yNpDJq65FeMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 2018-12-01 09:42:38 [+0100], Arnd Bergmann wrote:
> You are right that you can't take (or release) a mutex from interrupt
> context. However, I don't think converting a spinlock to a semaphore
> is going to help here either.

you can acquire a semaphore with a try_lock from interrupts context but
you can't do that with a mutex. You can also a acquire a semaphore in
one context and release in another. Not that I'm a fan of those things
but those two are often the reasons why people stick with a semaphore.

I haven't looked a general picture yet, will try to do so later today or
tomorrow.

>         Arnd

Sebastian
