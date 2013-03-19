From: shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org
Subject: efivarfs: Bad directory entry when variable has / in name
Date: Tue, 19 Mar 2013 16:36:30 -0400
Message-ID: <4764b7f1f5e6d79938d476ea68b99199@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello,

When there is an EFI variable with a forward slash in its name, 
/sys/firmware/efi/efivars contains a directory entry with a forward 
slash, which of course causes all sorts of problems (e.g. EINVAL from 
stat(2)). Off the top of my head, I can think of two ways to handle 
this:

1. Simply skip such variables when making the sysfs entries
2. Come up with an escaping scheme, e.g. "a single backslash is 
actually a forward slash, two backslashes are actually a single 
backslash" or some such.

Thoughts?

Cheers,
Shea Levy

P.S. Here is the program I ran to get the problematic efi variable, 
which worked on qemu+OMVF and a macbook pro 9,2:

EFI_STATUS EFIAPI Main(
                 IN EFI_HANDLE ImageHandle,
                 IN EFI_SYSTEM_TABLE *SystemTable
                 )
{
         EFI_GUID var_guid = { 0x38bd6e09, 0x70b3, 0x48f0, {0x8e, 0xa2, 
0x87, 0x25, 0x0c, 0xc3, 0x27, 0x71} };
         CHAR16 *var_name = L"a/directory";
         CHAR8 data = '\0';
         EFI_STATUS status;

         return SystemTable->RuntimeServices->SetVariable(
                         var_name,
                         &var_guid,
                         
EFI_VARIABLE_BOOTSERVICE_ACCESS|EFI_VARIABLE_RUNTIME_ACCESS,
                         sizeof data,
                         &data
                         );
}
