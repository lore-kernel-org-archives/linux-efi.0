From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] pstore: Convert buf_lock to semaphore
Date: Tue, 4 Dec 2018 19:06:12 +0100
Message-ID: <20181204180612.z4az5yplw5oqb26a@linutronix.de>
References: <20181130224736.GA38485@beast>
 <20181204154056.iyf333bcxqwk3obe@linutronix.de>
 <CAGXu5jLUMW3cCi1KVdSmOVn3O9BQ6ptYnyJbLHxojgzXd_YUxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLUMW3cCi1KVdSmOVn3O9BQ6ptYnyJbLHxojgzXd_YUxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 2018-12-04 09:23:13 [-0800], Kees Cook wrote:
> Okay, so, if kmsg_dump() uses rcu_read_lock(), that means efi-pstore
> can _never_ sleep, and it's nothing to do with pstore internals. :( I
> guess we just hard-code it, then? And efi-pstore should probably only
> attach to pstore if it has a nonblock implementation (and warn if one
> isn't available).

I was about to suggest that. I am not aware if anything else could use
efi_pstore_write() use that but otherwise you could hardcode it.

> -Kees
> 
Sebastian
