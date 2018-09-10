From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH v6 1/3] x86/boot: Add acpitb.c to parse acpi tables
Date: Mon, 10 Sep 2018 22:13:49 +0200
Message-ID: <CAJZ5v0gep7Q4w+yOvgfOUG8rU12tYEw3qtDKCoZN2=b8-=-fjw@mail.gmail.com>
References: <20180910124015.18073-1-fanc.fnst@cn.fujitsu.com> <20180910124015.18073-2-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910124015.18073-2-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: fanc.fnst@cn.fujitsu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, bhe@redhat.com, indou.takao@jp.fujitsu.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 10, 2018 at 2:41 PM Chao Fan <fanc.fnst@cn.fujitsu.com> wrote:
>
> Imitate the ACPI code of parsing ACPI tables to dig and read ACPI
> tables.

Why?

> Since some operations are not needed here,

What operations?

> functions are simplified. Functions will be used to dig SRAT tables to get
> information of memory, so that KASLR can the memory in immovable node.

So do you want to parse SRAT only or do something in addition to that?

> And also, these functions won't influence the initialization of
> ACPI after start_kernel().
