Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574EA33F595
	for <linux-efi@vger.kernel.org>; Sun,  9 Aug 2026 04:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786249000; cv=none; b=bQsGv/D1q7o8ZVTX4TBYkJmsVgZwiF6/ftX9BIhh6aclAzFUi7hljLrEb0D9661lyikibxLTh4TFK6jQJESOC4FutzyMj7vLeS4R14U53Tu1e+DvqwE0BxBImFFMEV5nfKCncjIFkvzzQmHYCBPr8mg9wILowz69FoiHGqr7AR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786249000; c=relaxed/simple;
	bh=Lw1f4Qfh+VH03kAlLDwA8wXMwI/hEo4zF6FRDGW02CM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hktglFwr4P//Dfgp+gq7bwhrcl/G7RykC6B+S3efACFwqVtBlur1dfwLhF7LXhLJjBiMhPGpjamfh3+N6EAo/r+0xGJO5PNuYpVdtAAnLVlk2j1CG8YoFN6SCTjh66obUa5NZ0hz6w9UkGaW5I3Hbpu1vdY9dpUxannJDTCDay8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xsif203G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xsif203G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03181F00ADB
	for <linux-efi@vger.kernel.org>; Sun,  9 Aug 2026 04:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786248998;
	bh=WEJfTEDHJt9NLvc9wWmqXGDB9HdtwB+EfSEcVZv5fUE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Xsif203G7VaCiG1PzPp0/RgnSSQfomKj7Kse/6bOn1VHXaop30K6haKnOAjMUY3Tj
	 paKF5D+xUzXjmf4x3xQCk2eiN+n8no5VvwZxhYg1idvcIPFqEa3Sp1DYIRembuocMu
	 Hzx2RTRxB6BSKfKu8NtMZNeYERcEvHQCIWwkohbYj0Kg8DKKOoyLZC/R4NtbBocuPV
	 hW54pk8rqAxUdxqHZKKUXbcI2TugBAqQx6/BaaJRNiEMAr1geSKFblNn7FGMZEldhB
	 xa3WceM6CrRQbJXL4yXsl138USOVgPxo5mlV6nmzlQ5HCCiyP84SMXA+iFGynQW7ms
	 1tROfhJPh9sYA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a082b3671fso766607a12.3
        for <linux-efi@vger.kernel.org>; Sat, 08 Aug 2026 21:16:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrme5bUjyIr/cRDJoiJMGyLdwdwjSy1Cqy6hCX+3nwoXSXPiOGSTIG1NjTphTJtE6dcSRLY328MYDs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/lfPdmDpoKWf9uDEfcoEQSzwEW8UVg5WDuhTNEQxl+qI9UzFL
	P5hlirI0rsOHOnmQHsm0i2nPQxagK4h827LfdkWzTu0s0axe1VoGav01Ti14WvuLXIi+jEQSkG0
	akTIND43o+5peS80u7hLUubI6cTsxUMs=
X-Received: by 2002:a05:6402:916:b0:6a1:2efd:8687 with SMTP id
 4fb4d7f45d1cf-6a14f132690mr17469409a12.14.1786248997461; Sat, 08 Aug 2026
 21:16:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-5-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-5-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 9 Aug 2026 12:16:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
X-Gm-Features: AUfX_mznkXpFMDYsM8EQmNDhdR03Th0a7eD16k8LboAyBQB4rd5wtvUyIPPIU6w
Message-ID: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org, 
	Kexin Liu <liukexin@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, George,

On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> Add loongarch.conf to configure QEMU's LoongArch virtual machine (VM)
> with a la464 CPU, enable the 8250 serial console, and set the kernel
> image to vmlinux.efi.  Extend vmtest.sh to recognise loongarch64 as a
> supported target and map it to the 'loongarch' kernel arch name.
>
> QEMU's LoongArch VM provides no ACPI tables and relies on FDT to
> describe hardware.  Without 'earlycon' on the kernel command line, the
> FDT is not scanned for a console UART, no output reaches the console,
> and vmtest.sh's console log stays empty causing the test to always
> fail.  Add 'earlycon' to KERNEL_CMDLINE in loongarch.conf.
>
> QEMU's LoongArch VM has no i8042 PS/2 controller.  When PNP detection
> finds nothing, i8042_init() falls back to probing the ports directly.
> On LoongArch the I/O ports are memory-mapped, and the i8042 port
> addresses are not backed by any device on the VM, so i8042_flush() takes
> a page fault and the kernel panics:
>
>   i8042: PNP: No PS/2 controller found.
>   i8042: Probing ports directly.
>   CPU 0 Unable to handle kernel paging request at virtual address ffff800=
000008064
>   ERA: i8042_flush+0x50/0x198
>    RA: i8042_init+0x2a8/0x35c
>   Kernel panic - not syncing: Attempted to kill init!
You never answer me why in your test you should disable i8042 from V1
until V4. In normal use we use a single kernel for both host and
guest.

Huacai

>
> Disable SERIO_I8042 and its dependents (KEYBOARD_ATKBD, MOUSE_PS2) in
> the QEMU_KCONFIG fragment to prevent the driver from being built.
> All three options are scoped to loongarch.conf; no other architecture
> is affected.
>
> Wrap the QEMU invocation in run_qemu() with timeout(1) using a local
> time limit so the test always terminates, even when QEMU does not exit
> on its own.  This is useful for every architecture; on LoongArch, for
> example, QEMU provides no EFI runtime services and machine_restart()
> falls through to an idle loop after kexec, so QEMU would never exit
> otherwise.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  tools/testing/selftests/kho/loongarch.conf | 11 +++++++++++
>  tools/testing/selftests/kho/vmtest.sh      | 22 +++++++++++++++-------
>  2 files changed, 26 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/kho/loongarch.conf
>
> diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/s=
elftests/kho/loongarch.conf
> new file mode 100644
> index 000000000000..e45fe1014cf3
> --- /dev/null
> +++ b/tools/testing/selftests/kho/loongarch.conf
> @@ -0,0 +1,11 @@
> +QEMU_CMD=3D"qemu-system-loongarch64 -M virt -cpu la464"
> +QEMU_KCONFIG=3D"
> +CONFIG_SERIAL_8250=3Dy
> +CONFIG_SERIAL_8250_CONSOLE=3Dy
> +CONFIG_SPARSEMEM_MANUAL=3Dy
> +# CONFIG_KEYBOARD_ATKBD is not set
> +# CONFIG_MOUSE_PS2 is not set
> +# CONFIG_SERIO_I8042 is not set
> +"
> +KERNEL_IMAGE=3D"vmlinux.efi"
> +KERNEL_CMDLINE=3D"console=3DttyS0 earlycon kho_scratch=3D16M,16M,16M"
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selfte=
sts/kho/vmtest.sh
> index 0014bd76e88d..de6aa59cf5a0 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -21,7 +21,7 @@ Options:
>         -d)     path to the kernel build directory
>         -j)     number of jobs for compilation, similar to -j in make
>         -t)     run test for target_arch, requires CROSS_COMPILE set
> -               supported targets: aarch64, x86_64
> +               supported targets: aarch64, x86_64, loongarch64
>         -h)     display this help
>  EOF
>  }
> @@ -111,12 +111,19 @@ function run_qemu() {
>
>         cmdline=3D"$cmdline kho=3Don panic=3D-1"
>
> -       $qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
> -                 -accel kvm -accel hvf -accel tcg  \
> -                 -serial file:"$serial" \
> -                 -append "$cmdline" \
> -                 -kernel "$kernel" \
> -                 -initrd "$initrd"
> +       local qemu_args=3D(
> +               -m 1G -smp 2 -no-reboot -nographic -nodefaults
> +               -accel kvm -accel hvf -accel tcg
> +               -serial file:"$serial"
> +               -append "$cmdline"
> +               -kernel "$kernel"
> +               -initrd "$initrd"
> +       )
> +
> +       # Bound the QEMU run so the test always terminates, even when QEM=
U
> +       # does not exit on its own (e.g. no EFI runtime services after ke=
xec).
> +       local qemu_timeout=3D60
> +       timeout "$qemu_timeout" $qemu_cmd "${qemu_args[@]}" || true
>
>         grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO =
failed"
>  }
> @@ -127,6 +134,7 @@ function target_to_arch() {
>         case $target in
>              aarch64) echo "arm64" ;;
>              x86_64) echo "x86" ;;
> +            loongarch64) echo "loongarch" ;;
>              *) skip "architecture $target is not supported"
>         esac
>  }
> --
> 2.53.0
>
