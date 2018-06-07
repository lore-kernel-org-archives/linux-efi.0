From: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v3 2/3] x86/asm: add _ASM_ARG* constants for argument
 registers to <asm/asm.h>
Date: Thu, 7 Jun 2018 13:13:56 -0700
Message-ID: <2f7fc4bf-d0fe-0d3a-ffdd-02cc82c83747@linux.intel.com>
References: <20180607183219.192973-1-ndesaulniers@google.com>
 <20180607183219.192973-3-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607183219.192973-3-ndesaulniers@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com, acme@redhat.com, pombredanne@nexb.com, aryabinin@virtuozzo.com, kstewart@linuxfoundation.org, boris.ostrovsky@oracle.com, jan.kiszka@siemens.com, rostedt@goodmis.org, kirill.shutemov@linux.intel.com, ard.biesheuvel@linaro.org, akataria@vmware.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.co
List-Id: linux-efi@vger.kernel.org

On 06/07/18 11:32, Nick Desaulniers wrote:
> 
> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>

If this was suggested by Sedat, I didn't see that suggestion...

	-hpa
