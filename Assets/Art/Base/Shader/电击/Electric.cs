using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Electric : MonoBehaviour
{
    public Camera cam;
    public GameObject effect;
    public float effectCD;
    public GameObject Ring;


    float effectCDT;
    bool effectIsFire = false;

    void Update()
    {
        //���λ�û�ȡ(���߼��)
        Ray mouseray=cam.ScreenPointToRay(Input.mousePosition);
        Physics.Raycast(mouseray, out RaycastHit rayhit, 1500, LayerMask.GetMask("plane"));
        Vector3 mousePosition = rayhit.point;
        Ring.transform.position = mousePosition;



        if (effectIsFire == false)
        {
            if (Input.GetMouseButtonDown(0))
            {
                //��¼CD,���������ʱ,CDTֵΪ���ڵ�ʱ��+effectCD,����CD������ʱ��,�����ڵ������ʱ����,CDT=5+3=8,�����ڵ�8��ʱ������ܲ��ܹ��ٴ��ͷ�
                effectCDT = effectCD + Time.time;
                //����Чλ���ƶ������λ��
                effect.transform.position = mousePosition;
                effect.SetActive(true);
                effectIsFire = true;
            }
        }


        if(Time.time >= effectCDT)//���ڵ�ʱ����ڵ����ս�ʱ��,�����CD����
        {
            effect.SetActive(false);
            effectIsFire = false;
        }

    }
}
