From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC-resend 1/2] x86/compat: Adjust in_compat_syscall() to generic code under !COMPAT
Date: Fri, 12 Oct 2018 07:57:50 -0700
Message-ID: <6135DDE6-C8C1-420E-A264-7FD0AB60DE82@amacapital.net>
References: <20181012134253.23266-1-dima@arista.com> <20181012134253.23266-2-dima@arista.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012134253.23266-2-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirsky <luto@kernel.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>, Steffen Klassert <steffen.klassert@secunet.com>, Stephen Boyd <sboyd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, linux-efi@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-efi@vger.kernel.org



> On Oct 12, 2018, at 6:42 AM, Dmitry Safonov <dima@arista.com> wrote:
> 
> The result of in_compat_syscall() can be pictured as:
> 
> x86 platform:
>    ---------------------------------------------------
>    |  Arch\syscall  |  64-bit  |   ia32   |   x32    |
>    |-------------------------------------------------|
>    |     x86_64     |  false   |   true   |   true   |
>    |-------------------------------------------------|
>    |      i686      |          |  <true>  |          |
>    ---------------------------------------------------
> 
> Other platforms:
>    -------------------------------------------
>    |  Arch\syscall  |  64-bit  |   compat    |
>    |-----------------------------------------|
>    |     64-bit     |  false   |    true     |
>    |-----------------------------------------|
>    |    32-bit(?)   |          |   <false>   |
>    -------------------------------------------
> 
> 

Yikes. This is probably even my fault!

Reviewed-by: Andy Lutomirski <luto@kernel.org>

And, if you want:

Apologized-for-by: Andy Lutomirski <luto@kernel.org>
