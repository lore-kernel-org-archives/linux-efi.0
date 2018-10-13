From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Sun, 14 Oct 2018 00:05:41 +0200
Message-ID: <20181013220541.GI31650@zn.tnic>
References: <20181010090620.GF25297@MiWiFi-R3L-srv>
 <alpine.DEB.2.21.1810101113070.10278@nanos.tec.linutronix.de>
 <20181010091923.GC5533@zn.tnic>
 <20181010093057.GA22088@MiWiFi-R3L-srv>
 <20181010194443.sgdvplwdnltshwwi@gabell>
 <20181011002955.GJ25297@MiWiFi-R3L-srv>
 <20181011055154.GB6667@localhost.localdomain>
 <20181013201958.zfzv5ahhe3xz7bwi@gabell>
 <20181013203429.GE31650@zn.tnic>
 <20181013214550.ag5qzokhkrkwnzsy@gabell>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013214550.ag5qzokhkrkwnzsy@gabell>
Sender: linux-kernel-owner@vger.kernel.org
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Chao Fan <fanc.fnst@cn.fujitsu.com>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 13, 2018 at 05:45:51PM -0400, Masayoshi Mizuma wrote:
> Yes, but I think we need to arrange the Chao's SRAT parsing to be used
> from kernel_randomize_memory() because Chao's approach needs the SRAT
> parsing before extract kernel and the padding size calculation needs
> the parsing in start_kernel(), so they are living in different life
> cycle and space.

Or you would like to pass some info from the compressed kernel to kernel
proper?

For example, something like the passing in add_e820ext() and the consumtion
in parse_setup_data():

                switch (data_type) {
                case SETUP_E820_EXT:
                        e820__memory_setup_extended(pa_data, data_len);

So info you need for your padding gets collected in
arch/x86/boot/compressed/acpitb.c and you consume it in
kernel_randomize_memory()?

Would that work?

:-)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
