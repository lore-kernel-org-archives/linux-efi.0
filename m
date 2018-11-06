From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [PATCH v8 0/3] x86/boot/KASLR: Parse ACPI table and limit kaslr
 in immovable memory
Date: Tue, 6 Nov 2018 17:21:34 -0500
Message-ID: <20181106222133.lb7674yzszivzihd@gabell>
References: <20181016151353.punyk7exekut2543@gabell>
 <20181016191113.GI5212@zn.tnic>
 <20181016195429.tovdgqq77gz3eek2@gabell>
 <20181016195902.GK5212@zn.tnic>
 <20181022154204.kagmdb55jtoez4ca@gabell>
 <20181025103345.GF14020@nazgul.tnic>
 <20181025134050.ggiir77ehntikbwg@gabell>
 <20181106184519.GA16391@zn.tnic>
 <20181106193636.svyjwuwrlgnpuyyf@gabell>
 <20181106204511.GO13712@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181106204511.GO13712@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, rjw@rjwysocki.net, lenb@kernel.org, ard.biesheuvel@linaro.org, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 06, 2018 at 09:45:11PM +0100, Borislav Petkov wrote:
> On Tue, Nov 06, 2018 at 02:36:38PM -0500, Masayoshi Mizuma wrote:
> > Yes, I think I can see what you are saying. However, I'm not sure how
> > I use the setup_data in legacy BIOS environment.
> 
> What is "legacy BIOS environment" and what does that have to do with
> setup_data?

My proposed patch [1] is useful only for EFI environment. The patch
allocates a setup_date structure by efi_call_early() and store the
KASLR data into the memory area.

+static void setup_kaslr(struct boot_params *params)
+{
+	struct setup_data *kaslr_data = NULL;
+	struct setup_data *data;
+	unsigned long size;
+	efi_status_t status;
+
+	size = sizeof(struct setup_data) + sizeof(unsigned long long);
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+			size, (void **)&kaslr_data);

I'm not sure how I allocate such memory on no EFI environment.
Am I missing something...?

[1] https://lkml.kernel.org/r/20181022154204.kagmdb55jtoez4ca@gabell

Thanks,
Masa
