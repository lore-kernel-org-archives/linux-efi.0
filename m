From: joeyli <jlee@suse.com>
Subject: Re: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
Date: Thu, 05 Sep 2013 11:13:16 +0800
Message-ID: <1378350796.6380.78.camel@linux-s257.site>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, keescook@chromium.org, hpa@zytor.com
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-09-03 =E6=96=BC 19:50 -0400=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> UEFI Secure Boot provides a mechanism for ensuring that the firmware =
will
> only load signed bootloaders and kernels. Certain use cases may also
> require that all kernel modules also be signed. Add a configuration o=
ption
> that enforces this automatically when enabled.
>=20
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Tested-by: Lee, Chun-Yi <jlee@suse.com>

Thanks
Joey Lee

> ---
>  Documentation/x86/zero-page.txt       |  2 ++
>  arch/x86/Kconfig                      | 10 ++++++++++
>  arch/x86/boot/compressed/eboot.c      | 36 +++++++++++++++++++++++++=
++++++++++
>  arch/x86/include/uapi/asm/bootparam.h |  3 ++-
>  arch/x86/kernel/setup.c               |  6 ++++++
>  include/linux/module.h                |  6 ++++++
>  kernel/module.c                       |  7 +++++++
>  7 files changed, 69 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero=
-page.txt
> index 199f453..ec38acf 100644
> --- a/Documentation/x86/zero-page.txt
> +++ b/Documentation/x86/zero-page.txt
> @@ -30,6 +30,8 @@ Offset	Proto	Name		Meaning
>  1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
>  1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig=
_buffer
>  				(below)
> +1EB/001	ALL     kbd_status      Numlock is enabled
> +1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
>  1EF/001	ALL	sentinel	Used to detect broken bootloaders
>  290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
>  2D0/A00	ALL	e820_map	E820 memory map table
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b32ebf9..6a6c19b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1581,6 +1581,16 @@ config EFI_STUB
> =20
>  	  See Documentation/x86/efi-stub.txt for more information.
> =20
> +config EFI_SECURE_BOOT_SIG_ENFORCE
> +        def_bool n
> +	prompt "Force module signing when UEFI Secure Boot is enabled"
> +	---help---
> +	  UEFI Secure Boot provides a mechanism for ensuring that the
> +	  firmware will only load signed bootloaders and kernels. Certain
> +	  use cases may also require that all kernel modules also be signed=
=2E
> +	  Say Y here to automatically enable module signature enforcement
> +	  when a system boots with UEFI Secure Boot enabled.
> +
>  config SECCOMP
>  	def_bool y
>  	prompt "Enable seccomp to safely compute untrusted bytecode"
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compres=
sed/eboot.c
> index b7388a4..53bfe4f 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -12,6 +12,7 @@
>  #include <asm/efi.h>
>  #include <asm/setup.h>
>  #include <asm/desc.h>
> +#include <asm/bootparam_utils.h>
> =20
>  #undef memcpy			/* Use memcpy from misc.c */
> =20
> @@ -861,6 +862,37 @@ fail:
>  	return status;
>  }
> =20
> +static int get_secure_boot(void)
> +{
> +	u8 sb, setup;
> +	unsigned long datasize =3D sizeof(sb);
> +	efi_guid_t var_guid =3D EFI_GLOBAL_VARIABLE_GUID;
> +	efi_status_t status;
> +
> +	status =3D efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
> +
> +	if (status !=3D EFI_SUCCESS)
> +		return 0;
> +
> +	if (sb =3D=3D 0)
> +		return 0;
> +
> +
> +	status =3D efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SetupMode", &var_guid, NULL, &datasize,
> +				&setup);
> +
> +	if (status !=3D EFI_SUCCESS)
> +		return 0;
> +
> +	if (setup =3D=3D 1)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +
>  /*
>   * Because the x86 boot code expects to be passed a boot_params we
>   * need to create one ourselves (usually the bootloader would create
> @@ -1169,6 +1201,10 @@ struct boot_params *efi_main(void *handle, efi=
_system_table_t *_table,
>  	if (sys_table->hdr.signature !=3D EFI_SYSTEM_TABLE_SIGNATURE)
>  		goto fail;
> =20
> +	sanitize_boot_params(boot_params);
> +
> +	boot_params->secure_boot =3D get_secure_boot();
> +
>  	setup_graphics(boot_params);
> =20
>  	setup_efi_pci(boot_params);
> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include=
/uapi/asm/bootparam.h
> index c15ddaf..85d7685 100644
> --- a/arch/x86/include/uapi/asm/bootparam.h
> +++ b/arch/x86/include/uapi/asm/bootparam.h
> @@ -131,7 +131,8 @@ struct boot_params {
>  	__u8  eddbuf_entries;				/* 0x1e9 */
>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
>  	__u8  kbd_status;				/* 0x1eb */
> -	__u8  _pad5[3];					/* 0x1ec */
> +	__u8  secure_boot;				/* 0x1ec */
> +	__u8  _pad5[2];					/* 0x1ed */
>  	/*
>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
>  	 *
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f8ec578..deeb7bc 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1129,6 +1129,12 @@ void __init setup_arch(char **cmdline_p)
> =20
>  	io_delay_init();
> =20
> +#ifdef CONFIG_EFI_SECURE_BOOT_SIG_ENFORCE
> +	if (boot_params.secure_boot) {
> +		enforce_signed_modules();
> +	}
> +#endif
> +
>  	/*
>  	 * Parse the ACPI tables for possible boot-time SMP configuration.
>  	 */
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 0c266b2..5a6374a 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -184,6 +184,12 @@ const struct exception_table_entry *search_excep=
tion_tables(unsigned long add);
> =20
>  struct notifier_block;
> =20
> +#ifdef CONFIG_MODULE_SIG
> +extern void enforce_signed_modules(void);
> +#else
> +static inline void enforce_signed_modules(void) {};
> +#endif
> +
>  #ifdef CONFIG_MODULES
> =20
>  extern int modules_disabled; /* for sysctl */
> diff --git a/kernel/module.c b/kernel/module.c
> index 0e94acf..974139b 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3853,6 +3853,13 @@ void module_layout(struct module *mod,
>  EXPORT_SYMBOL(module_layout);
>  #endif
> =20
> +#ifdef CONFIG_MODULE_SIG
> +void enforce_signed_modules(void)
> +{
> +	sig_enforce =3D true;
> +}
> +#endif
> +
>  bool secure_modules(void)
>  {
>  #ifdef CONFIG_MODULE_SIG
