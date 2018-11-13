From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v11 2/5] x86/boot: Add bios_get_rsdp_addr() to search
 RSDP in memory
Date: Tue, 13 Nov 2018 11:09:12 +0100
Message-ID: <20181113100912.GA10502@zn.tnic>
References: <20181112094645.4879-1-fanc.fnst@cn.fujitsu.com>
 <20181112094645.4879-3-fanc.fnst@cn.fujitsu.com>
 <20181112152744.GG8167@zn.tnic>
 <20181113021016.GC7453@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113021016.GC7453@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, bhe@redhat.com, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 13, 2018 at 10:10:16AM +0800, Chao Fan wrote:
> The 'rover' was named as 'mem_rover', but the length of this line is too
> long. So shorten it as 'rever' so that they can keep in one line.

I still have no clue what "rover" or "rever" means...

> This name came from ACPI driver code, acpi_find_root_pointer().
> Used for the loop. If you have a better name, please tell me.

I would if I knew what it meant. If you don't know either, then name it
to something descriptive so that it is clear what it is when reading the
code.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
